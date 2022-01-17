import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_requested.dart';
import 'package:TransitEasy/blocs/events/schedulednotifications/create_scheduled_notification_requested.dart';
import 'package:TransitEasy/blocs/schedulednotifications_bloc.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_success.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_state.dart';
import 'package:TransitEasy/blocs/states/schedulednotifications/scheduled_notification_add_succeeded.dart';
import 'package:TransitEasy/blocs/stopnumbersearch_bloc.dart';
import 'package:TransitEasy/clients/models/nextbus_schedule_status.dart';
import 'package:TransitEasy/clients/models/nextbus_stop_info.dart';
import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/common/widgets/error/error_page.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class PinnedStopSearchScreen extends StatefulWidget {
  final StopInfoStreamModel _model;
  final StopNumberSearchBloc _nextBusScheduleBloc;
  final ScheduledNotificationsBloc _scheduledNotificationsBloc;

  PinnedStopSearchScreen(
      this._model, this._nextBusScheduleBloc, this._scheduledNotificationsBloc);

  @override
  State<StatefulWidget> createState() => _PinnedStopSearchScreenState(
      _model, _nextBusScheduleBloc, _scheduledNotificationsBloc);
}

class _PinnedStopSearchScreenState extends State<PinnedStopSearchScreen> {
  final StopInfoStreamModel _model;
  final StopNumberSearchBloc _nextBusScheduleBloc;
  final ScheduledNotificationsBloc _scheduledNotificationsBloc;
  final NavBar _navBar = new NavBar();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<GoogleMapController> _controller = Completer();
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

  _PinnedStopSearchScreenState(
      this._model, this._nextBusScheduleBloc, this._scheduledNotificationsBloc);

  @override
  void initState() {
    _fToast.init(context);
    _nextBusScheduleBloc.add(NextBusScheduleRequested(
        _model.stopNo, _model.stopLat, _model.stopLong));
    super.initState();
  }

  Widget buildMap() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
          target: LatLng(_model.stopLat, _model.stopLong), zoom: 17.0),
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
      markers: {
        new Marker(
            markerId: MarkerId("stop_location"),
            position: LatLng(_model.stopLat, _model.stopLong),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure))
      },
      zoomControlsEnabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
                alignment: Alignment.topLeft,
                color: appPageColor,
                child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 110.0, horizontal: 0.0),
                    child:
                        BlocBuilder<StopNumberSearchBloc, NextBusScheduleState>(
                      bloc: _nextBusScheduleBloc,
                      builder: (context, state) {
                        if (state is NextBusScheduleLoadInProgress) {
                          return getLoadingScreen();
                        } else if (state is NextBusScheduleLoadSuccess) {
                          return Column(children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.cyanAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor)),
                              child: Text(
                                  "${_model.stopNo}: ${_model.stopName}",
                                  style: appFont),
                            ),
                            Container(
                                child: SizedBox(height: 300, child: buildMap()),
                                alignment: Alignment.center,
                                color: appPageColor),
                            getNextBusSchedulesList(
                                state.nextBusStopInfo, context)
                          ]);
                        } else {
                          return ErrorPage();
                        }
                      },
                    ))),
            FloatingMenu(onTap: () => _scaffoldKey.currentState!.openDrawer())
          ],
        ),
        drawer: _navBar);
  }

  Widget getNextBusSchedulesList(
      List<NextBusStopInfo>? nextBusStopInfo, BuildContext context) {
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
    return Expanded(
        child: SizedBox(
            height: 200.0,
            child: ListView(
              children: nextBusStopInfo
                  .map((e) => Container(
                        decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
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
                                        trailing: Text(
                                            "${schedule.countdownInMin} min"),
                                      ),
                                      onPressed: () {},
                                      menuItems: [
                                        FocusedMenuItem(
                                            title: Text("Create reminder"),
                                            trailingIcon: Icon(Icons.alarm_add),
                                            onPressed: () {
                                              _scheduledNotificationsBloc
                                                  .handleEvent(
                                                      CreateScheduledNotificationRequested(
                                                schedule.expectedLeaveTime,
                                                e.routeDescription,
                                                schedule.destination,
                                                _model.stopNo.toString(),
                                              ))
                                                  .then((value) {
                                                if (value
                                                    is ScheduledNotificationAddSucceeded) {
                                                  _fToast.showToast(
                                                      child: _successToast,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      toastDuration:
                                                          Duration(seconds: 2));
                                                } else {
                                                  _fToast.showToast(
                                                      child: _failToast,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      toastDuration:
                                                          Duration(seconds: 2));
                                                }
                                              });
                                            })
                                      ]))
                              .toList(),
                          childrenPadding: EdgeInsets.all(10.0),
                        ),
                      ))
                  .toList(),
            )));
  }

  String getStatusString(NextBusScheduleStatus status) {
    if (status == NextBusScheduleStatus.ONTIME)
      return "ON TIME";
    else if (status == NextBusScheduleStatus.AHEAD)
      return "AHEAD";
    else
      return "DELAYED";
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
}
