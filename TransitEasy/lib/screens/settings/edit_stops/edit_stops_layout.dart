import 'dart:async';
import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_requested.dart';
import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_decremented.dart';
import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_incremented.dart';
import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_initial.dart';
import 'package:TransitEasy/blocs/locationradiusconfig_bloc.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_failed.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_success.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_state.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/common/widgets/error/error_page.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constants.dart';

class EditStopsLayout extends StatefulWidget {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  final LocationRadiusConfigBloc locationRadiusConfigBloc;
  EditStopsLayout(this.stopsLocationsMapBloc, this.locationRadiusConfigBloc);
  @override
  State<StatefulWidget> createState() =>
      EditStopsLayoutState(stopsLocationsMapBloc, locationRadiusConfigBloc);
}

class EditStopsLayoutState extends State<EditStopsLayout> {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  final LocationRadiusConfigBloc locationRadiusConfigBloc;
  final SettingsService _settingsService = SettingsService();

  int _previousChosenValue = 0;
  bool _isSaveEnabled = false;
  Completer<GoogleMapController> _controller = Completer();
  late GoogleMapController _mapController;

  late double _sliderValue;

  EditStopsLayoutState(
      this.stopsLocationsMapBloc, this.locationRadiusConfigBloc);

  void handleOnSavePress() {
    _settingsService
        .setStopsSearchRadiusMetersSetting(_sliderValue.toInt())
        .then((result) => {
              if (result)
                {
                  Fluttertoast.showToast(
                      msg: "Setting updated succesfully!",
                      gravity: ToastGravity.BOTTOM,
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.greenAccent,
                      textColor: Colors.black),
                  Navigator.pop(context)
                }
            });
  }

  void handleOnCancelPress() => Navigator.pop(context);

  Widget _handleMapLoadSuccess(
      StopsLocationMapLoadSucess mapSuccessState, BuildContext context) {
    locationRadiusConfigBloc
        .add(LocationRadiusInitial(mapSuccessState.userRadiusSetting));
    return BlocBuilder<LocationRadiusConfigBloc, int>(
      builder: (builderContext, state) {
        return Column(
          children: [
            Container(
                child: SizedBox(
                    height: 300,
                    child:
                        _buildMapFromStateWithRadius(mapSuccessState, state)),
                alignment: Alignment.center,
                color: appPageColor),
            Slider(
              value: state.toDouble(),
              onChanged: (val) => {
                _sliderValue = val,
                if (val != mapSuccessState.userRadiusSetting)
                  {_isSaveEnabled = true}
                else if (val == mapSuccessState.userRadiusSetting)
                  {_isSaveEnabled = false},
                if (_previousChosenValue == 0)
                  {locationRadiusConfigBloc.add(LocationRadiusInitial(state))}
                else if (val > _previousChosenValue)
                  {locationRadiusConfigBloc.add(LocationRadiusIncremented(100))}
                else if (val < _previousChosenValue)
                  {
                    locationRadiusConfigBloc.add(LocationRadiusDecremented(100))
                  },
                _previousChosenValue = val.toInt()
              },
              min: 500,
              max: 1500,
              divisions: 10,
              label: state.toString(),
              inactiveColor: Color.fromRGBO(221, 160, 221, .6),
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: handleOnCancelPress,
                  child: Text(
                    "Cancel",
                    style:
                        FontBuilder.buildCommonAppThemeFont(16, Colors.black87),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.cyanAccent)),
                ),
                ElevatedButton(
                    onPressed: _isSaveEnabled ? handleOnSavePress : null,
                    child: Text(
                      "Save",
                      style: FontBuilder.buildCommonAppThemeFont(
                          16, Colors.black87),
                    ),
                    style: ButtonStyle(
                        backgroundColor: _isSaveEnabled
                            ? MaterialStateProperty.all<Color>(
                                Colors.cyanAccent)
                            : MaterialStateProperty.all<Color>(Colors.grey)))
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
        );
      },
    );
  }

  GoogleMap _buildMapFromStateWithRadius(
      StopsLocationMapLoadSucess mapSuccessState, int radius) {
    Set<Marker> markers = {};
    Set<Circle> radiusCircle = {};
    var userLocation = mapSuccessState.userLocation;
    var userLocationMarker = new Marker(
        markerId: MarkerId("user_loc_marker"),
        position: LatLng(mapSuccessState.userLocation.latitude,
            mapSuccessState.userLocation.longitude));
    markers.add(userLocationMarker);
    radiusCircle.add(Circle(
        center: LatLng(mapSuccessState.userLocation.latitude,
            mapSuccessState.userLocation.longitude),
        strokeWidth: 2,
        fillColor: Color.fromRGBO(221, 160, 221, .6),
        strokeColor: appPageColor,
        radius: radius.toDouble(),
        circleId: CircleId("selected_range")));
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: 14.0),
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
          _mapController = controller;
        }
      },
      markers: markers,
      circles: radiusCircle,
      zoomControlsEnabled: true,
      zoomGesturesEnabled: true,
      compassEnabled: true,
    );
  }

  void _animateZoomOut(double radius) {
    var zoomFactor = _getZoomFactor(radius);
    _mapController.animateCamera(CameraUpdate.zoomBy(-zoomFactor));
  }

  void _animateZoomIn(double radius) {
    var zoomFactor = _getZoomFactor(radius);
    _mapController.animateCamera(CameraUpdate.zoomBy(zoomFactor));
  }

  double _getZoomFactor(double radius) {
    if (radius < 300)
      return 0.5;
    else
      return 0.2;
  }

  Widget getLoadingScreen() {
    return Container(
        child: SizedBox(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(221, 160, 221, .6)),
          ),
          width: 60,
          height: 60,
        ),
        alignment: Alignment.center,
        color: appPageColor);
  }

  @override
  Widget build(BuildContext context) {
    stopsLocationsMapBloc
        .add(StopsLocationMapRequested((ev, stopInfo) {}, true));
    return BlocBuilder<StopsLocationsMapBloc, StopsLocationMapState>(
        bloc: stopsLocationsMapBloc,
        builder: (builderContext, state) {
          if (state is StopsLocationMapLoadSucess) {
            return Stack(
              children: [_handleMapLoadSuccess(state, context)],
            );
          } else if (state is StopsLocationMapLoadFailed) {
            return ErrorPage();
          }
          return getLoadingScreen();
        });
  }
}
