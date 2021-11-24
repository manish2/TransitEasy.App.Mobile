import 'dart:async';
import 'dart:developer' as developer;
import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_requested.dart';
import 'package:TransitEasy/blocs/events/schedulednotifications/create_scheduled_notification_requested.dart';
import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_requested.dart';
import 'package:TransitEasy/blocs/nextbusschedule_bloc.dart';
import 'package:TransitEasy/blocs/schedulednotifications_bloc.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_initial.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_success.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_state.dart';
import 'package:TransitEasy/blocs/states/schedulednotifications/scheduled_notification_add_succeeded.dart';
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
import 'package:TransitEasy/screen.dart';
import 'package:TransitEasy/screens/stopslocation/stop_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StopsLocationsLayout extends StatefulWidget {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  final NextBusScheduleBloc nextBusScheduleBloc;
  final ScheduledNotificationsBloc scheduledNotificationsBloc;

  StopsLocationsLayout(this.stopsLocationsMapBloc, this.nextBusScheduleBloc,
      this.scheduledNotificationsBloc);
  @override
  State<StatefulWidget> createState() => StopsLocationsLayoutState(
      stopsLocationsMapBloc, nextBusScheduleBloc, scheduledNotificationsBloc);
}

class StopsLocationsLayoutState extends State<StopsLocationsLayout> {
  final StopsLocationsMapBloc stopsLocationsMapBloc;
  final NextBusScheduleBloc nextBusScheduleBloc;
  final ScheduledNotificationsBloc scheduledNotificationsBloc;
  final FToast _fToast = FToast();
  final Widget _successToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Notification scheduled succesfully!"),
      ],
    ),
  );

  final Widget _failToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error),
        SizedBox(
          width: 12.0,
        ),
        Text("Failed to save schedule notification!"),
      ],
    ),
  );
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  late StreamController<String> _stopInfoStreamController;

  StopsLocationsLayoutState(this.stopsLocationsMapBloc,
      this.nextBusScheduleBloc, this.scheduledNotificationsBloc);

  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _stopInfoStreamController = StreamController<String>();
    _fToast.init(context);
  }

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

  Widget getNextBusSchedulesList(
      List<NextBusStopInfo>? nextBusStopInfo, int stopNumber) {
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

    List<Widget> nextBusLists = nextBusStopInfo
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
                    .map((schedule) => FocusedMenuHolder(
                          child: ListTile(
                            title: Text(schedule.destination),
                            subtitle: Text(
                                "STATUS: ${getStatusString(schedule.scheduleStatus)}"),
                            trailing: Text("${schedule.countdownInMin} min"),
                          ),
                          onPressed: () {},
                          menuItems: [
                            FocusedMenuItem(
                                title: Text("Remind me when this bus is close"),
                                trailingIcon: Icon(Icons.alarm_add),
                                onPressed: () {
                                  scheduledNotificationsBloc
                                      .handleEvent(
                                          CreateScheduledNotificationRequested(
                                    schedule.expectedLeaveTime,
                                    e.routeDescription,
                                    schedule.destination,
                                    stopNumber.toString(),
                                  ))
                                      .then((value) {
                                    if (value
                                        is ScheduledNotificationAddSucceeded) {
                                      _fToast.showToast(
                                          child: _successToast,
                                          gravity: ToastGravity.BOTTOM,
                                          toastDuration: Duration(seconds: 2));
                                    } else {
                                      _fToast.showToast(
                                          child: _failToast,
                                          gravity: ToastGravity.BOTTOM,
                                          toastDuration: Duration(seconds: 2));
                                    }
                                  });
                                })
                          ],
                        ))
                    .toList(),
                childrenPadding: EdgeInsets.all(10.0),
              ),
            ))
        .toList();

    List<Widget> nextBusList = nextBusStopInfo
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
        .toList();
    return ListView(
      children: nextBusLists,
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

  @override
  Widget build(BuildContext context) {
    stopsLocationsMapBloc.add(StopsLocationMapRequested(
        (ev, stopInfo) => showDialog(
            context: context, builder: (context) => StopDetails(stopInfo)),
        false));
    Future<NotificationSettings> notificationsRequest =
        _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return FutureBuilder(
        future: notificationsRequest,
        builder: (context, snapshot) {
          return SlidingUpPanel(
            maxHeight: Screen.height(context) * .7,
            header: StreamBuilder<String>(
                stream: _stopInfoStreamController.stream,
                initialData: "   No stops selected!   ",
                builder: (context, snapshot) => FocusedMenuHolder(
                        menuWidth: MediaQuery.of(context).size.width * 0.50,
                        blurSize: 5.0,
                        menuBoxDecoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        duration: Duration(milliseconds: 100),
                        animateMenuItems: true,
                        blurBackgroundColor: Colors.black54,
                        openWithTap: false,
                        menuOffset: 10.0,
                        child: Container(
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                color: Colors.cyanAccent,
                                child: Text(
                                    snapshot.hasData
                                        ? snapshot.data!
                                        : "   No stops selected!   ",
                                    style: FontBuilder.buildCommonAppThemeFont(
                                        20, Colors.black87)))),
                        onPressed: () => {},
                        menuItems: [
                          FocusedMenuItem(
                              title: Text("Pin stop"),
                              trailingIcon: Icon(
                                Icons.push_pin,
                                color: Colors.cyanAccent,
                              ),
                              onPressed: () => {
                                    developer.log('Pin Stop was pressed!',
                                        name: 'my.app.category')
                                  })
                        ])),
            panel: BlocBuilder<NextBusScheduleBloc, NextBusScheduleState>(
              bloc: nextBusScheduleBloc,
              builder: (context, state) {
                if (state is NextBusScheduleLoadSuccess) {
                  return Padding(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 0.0, top: 25.0, bottom: 0.0),
                      child: getNextBusSchedulesList(
                          state.nextBusStopInfo, state.stopNo));
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
                  padding: EdgeInsets.only(
                      left: 10.0, right: 0.0, top: 50.0, bottom: 0.0),
                  child: Container(
                    child:
                        Text("FAILED", style: TextStyle(color: Colors.white)),
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
        });
  }

  @override
  void dispose() {
    super.dispose();
    _stopInfoStreamController.close();
  }
}
