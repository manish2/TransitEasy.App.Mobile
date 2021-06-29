import 'dart:async';
import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_requested.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_success.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_state.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/clients/models/stop_info.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/stopslocation/stop_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopsLocationsLayout extends StatefulWidget {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  StopsLocationsLayout(this.stopsLocationsMapBloc);
  @override
  State<StatefulWidget> createState() =>
      StopsLocationsLayoutState(stopsLocationsMapBloc);
}

class StopsLocationsLayoutState extends State<StopsLocationsLayout> {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  final FToast _fToast = FToast();
  final Widget _noBusLocationsWarningToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.orangeAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.warning),
        SizedBox(
          width: 12.0,
        ),
        Text("Could not find any stops near your location"),
      ],
    ),
  );
  bool shouldShowWarningToast = false;
  StopsLocationsLayoutState(this.stopsLocationsMapBloc);

  final Completer<GoogleMapController> _controller = Completer();
  Widget handleMapLoadSuccess(
      StopsLocationMapLoadSucess mapSuccessState, BuildContext context) {
    if (mapSuccessState.busLocations.isEmpty) shouldShowWarningToast = true;
    return Stack(
      children: [
        _buildMapFromState(
            mapSuccessState,
            (StopInfo stopInfo) => showDialog(
                context: context, builder: (context) => StopDetails(stopInfo)))
      ],
    );
  }

  GoogleMap _buildMapFromState(StopsLocationMapLoadSucess mapSuccessState,
      Function(StopInfo stopInfo) onInfoTap) {
    Set<Marker> markers = {};
    Set<Circle> radiusCircle = {};
    var userLocation = mapSuccessState.userLocation;
    var stopLocationMarkers = mapSuccessState.busLocations.map((stopInfo) =>
        new Marker(
            markerId: MarkerId(stopInfo.stopNo.toString()),
            position: LatLng(stopInfo.latitude, stopInfo.longitude),
            infoWindow: InfoWindow(
                title: "${stopInfo.stopNo}: ${stopInfo.stopName}",
                snippet: "Click to see more details",
                onTap: () => onInfoTap(stopInfo))));
    var userLocationMarker = new Marker(
        markerId: MarkerId("user_loc_marker"),
        position: LatLng(mapSuccessState.userLocation.latitude,
            mapSuccessState.userLocation.longitude));
    markers.addAll(stopLocationMarkers);
    markers.add(userLocationMarker);
    radiusCircle.add(Circle(
        center: LatLng(mapSuccessState.userLocation.latitude,
            mapSuccessState.userLocation.longitude),
        strokeWidth: 2,
        fillColor: Color.fromRGBO(221, 160, 221, .6),
        strokeColor: appPageColor,
        radius: mapSuccessState.userRadiusSetting.toDouble(),
        circleId: CircleId("selected_range")));
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: 16.0),
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
      markers: markers,
      circles: radiusCircle,
      zoomControlsEnabled: true,
    );
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

  void initState() {
    super.initState();
    _fToast.init(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) => {
          if (shouldShowWarningToast)
            _fToast.showToast(
                child: _noBusLocationsWarningToast,
                toastDuration: Duration(seconds: 4))
        });
  }

  @override
  Widget build(BuildContext context) {
    stopsLocationsMapBloc.add(StopsLocationMapRequested((ev, stopInfo) =>
        showDialog(
            context: context, builder: (context) => StopDetails(stopInfo))));
    return BlocBuilder<StopsLocationsMapBloc, StopsLocationMapState>(
        bloc: stopsLocationsMapBloc,
        builder: (context, state) {
          return state is StopsLocationMapLoadSucess
              ? Stack(
                  children: [handleMapLoadSuccess(state, context)],
                )
              : getLoadingScreen();
        });
  }
}
