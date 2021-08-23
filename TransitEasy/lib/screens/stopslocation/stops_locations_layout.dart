import 'dart:async';
import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_requested.dart';
import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_requested.dart';
import 'package:TransitEasy/blocs/nextbusschedule_bloc.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_initial.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_success.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_state.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_failed.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_success.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_state.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/clients/models/nextbus_schedule_status.dart';
import 'package:TransitEasy/clients/models/nextbus_stop_info.dart';
import 'package:TransitEasy/clients/models/stop_info.dart';
import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/common/widgets/error/error_page.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/stopslocation/stop_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StopsLocationsLayout extends StatefulWidget {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  final NextBusScheduleBloc nextBusScheduleBloc;
  StopsLocationsLayout(this.stopsLocationsMapBloc, this.nextBusScheduleBloc);
  @override
  State<StatefulWidget> createState() =>
      StopsLocationsLayoutState(stopsLocationsMapBloc, nextBusScheduleBloc);
}

class StopsLocationsLayoutState extends State<StopsLocationsLayout> {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  final NextBusScheduleBloc nextBusScheduleBloc;
  final FToast _fToast = FToast();
  late StreamController<String> _stopInfoStreamController;
  StopsLocationsLayoutState(
      this.stopsLocationsMapBloc, this.nextBusScheduleBloc);

  final Completer<GoogleMapController> _controller = Completer();
  Widget handleMapLoadSuccess(
      StopsLocationMapLoadSucess mapSuccessState, BuildContext context) {
    return Stack(
      children: [
        _buildMapFromState(
            mapSuccessState,
            (StopInfo stopInfo) => showDialog(
                context: context, builder: (context) => StopDetails(stopInfo)),
            context)
      ],
    );
  }

  GoogleMap _buildMapFromState(StopsLocationMapLoadSucess mapSuccessState,
      Function(StopInfo stopInfo) onInfoTap, BuildContext context) {
    Set<Marker> markers = {};
    Set<Circle> radiusCircle = {};
    var userLocation = mapSuccessState.userLocation;
    var stopLocationMarkers = mapSuccessState.busLocations.map((stopInfo) =>
        new Marker(
            onTap: () => {
                  _stopInfoStreamController
                      .add("   ${stopInfo.stopNo}: ${stopInfo.stopName}   "),
                  nextBusScheduleBloc
                      .add(NextBusScheduleRequested(stopInfo.stopNo))
                },
            markerId: MarkerId(stopInfo.stopNo.toString()),
            position: LatLng(stopInfo.latitude, stopInfo.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure)));
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
          zoom: 14.4),
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
            valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
          ),
          width: 60,
          height: 60,
        ),
        alignment: Alignment.center,
        color: appPageColor);
  }

  Widget getNextBusSchedulesList(List<NextBusStopInfo>? nextBusStopInfo) {
    if (nextBusStopInfo == null || nextBusStopInfo.isEmpty) {
      return Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: Colors.cyanAccent,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Theme.of(context).primaryColor)),
        child: Text(
          "No data available for this stop",
          style: FontBuilder.buildCommonAppThemeFont(20, Colors.black87),
        ),
      );
    }
    return ListView(
      children: nextBusStopInfo
          .map((e) => Container(
                decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Theme.of(context).primaryColor)),
                child: ExpansionTile(
                  title: Container(
                    child: Text(e.routeDescription),
                  ),
                  children: e.schedules
                      .map((schedule) => ListTile(
                            title: Text(schedule.destination),
                            subtitle: Text(
                                "STATUS: ${getStatusString(schedule.scheduleStatus)}"),
                            trailing: Text("${schedule.countdownInMin} min"),
                          ))
                      .toList(),
                  childrenPadding: EdgeInsets.all(10.0),
                ),
              ))
          .toList(),
    );
  }

  String getStatusString(NextBusScheduleStatus status) {
    if (status == NextBusScheduleStatus.ONTIME)
      return "ON TIME";
    else if (status == NextBusScheduleStatus.AHEAD)
      return "AHEAD";
    else
      return "DELAYED";
  }

  void initState() {
    super.initState();
    _stopInfoStreamController = StreamController<String>();
    _fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    stopsLocationsMapBloc.add(StopsLocationMapRequested(
        (ev, stopInfo) => showDialog(
            context: context, builder: (context) => StopDetails(stopInfo)),
        false));
    return SlidingUpPanel(
      maxHeight: 800,
      header: StreamBuilder<String>(
          stream: _stopInfoStreamController.stream,
          initialData: "   No stops selected!   ",
          builder: (context, snapshot) => Container(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Colors.cyanAccent,
                  child: Text(
                      snapshot.hasData
                          ? snapshot.data!
                          : "   No stops selected!   ",
                      style: FontBuilder.buildCommonAppThemeFont(
                          20, Colors.black87))))),
      panel: BlocBuilder<NextBusScheduleBloc, NextBusScheduleState>(
        bloc: nextBusScheduleBloc,
        builder: (context, state) {
          if (state is NextBusScheduleLoadSuccess) {
            return Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 0.0, top: 25.0, bottom: 0.0),
                child: getNextBusSchedulesList(state.nextBusStopInfo));
          } else if (state is NextBusScheduleLoadInProgress ||
              state is NextBusScheduleInitial) {
            return Padding(
              padding: EdgeInsets.only(
                  left: 10.0, right: 0.0, top: 50.0, bottom: 0.0),
              child: Container(
                child: getLoadingScreen(),
              ),
            );
          }
          return Padding(
            padding:
                EdgeInsets.only(left: 10.0, right: 0.0, top: 50.0, bottom: 0.0),
            child: Container(
              child: Text("FAILED", style: TextStyle(color: Colors.white)),
            ),
          );
        },
      ),
      color: Color.fromRGBO(51, 0, 123, .95),
      backdropEnabled: true,
      backdropOpacity: 0.6,
      body: BlocBuilder<StopsLocationsMapBloc, StopsLocationMapState>(
          bloc: stopsLocationsMapBloc,
          builder: (context, state) {
            if (state is StopsLocationMapLoadSucess) {
              return Stack(
                children: [handleMapLoadSuccess(state, context)],
              );
            } else if (state is StopsLocationMapLoadFailed) {
              return ErrorPage();
            }
            return getLoadingScreen();
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _stopInfoStreamController.close();
  }
}
