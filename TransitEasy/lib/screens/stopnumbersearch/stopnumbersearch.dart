import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_requested.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_success.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_state.dart';
import 'package:TransitEasy/blocs/stopnumbersearch_bloc.dart';
import 'package:TransitEasy/clients/models/nextbus_schedule_status.dart';
import 'package:TransitEasy/clients/models/nextbus_stop_info.dart';
import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

class StopNumberSearchScreen extends StatelessWidget {
  final NavBar _navBar = new NavBar();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final StopNumberSearchBloc _nextBusScheduleBloc;
  final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Colors.cyanAccent,
      onPrimary: Colors.black87,
      textStyle: FontBuilder.buildCommonAppThemeFont(20, Colors.black87));
  final textFieldController = TextEditingController();

  StopNumberSearchScreen(this._nextBusScheduleBloc);

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
    );
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
                              .map((schedule) => ListTile(
                                    title: Text(schedule.destination),
                                    subtitle: Text(
                                        "STATUS: ${getStatusString(schedule.scheduleStatus)}"),
                                    trailing:
                                        Text("${schedule.countdownInMin} min"),
                                  ))
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(children: <Widget>[
          GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                  alignment: Alignment.topLeft,
                  color: appPageColor,
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 120.0, horizontal: 0.0),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            style: TextStyle(color: Colors.white),
                            controller: textFieldController,
                            textInputAction: TextInputAction.done,
                            decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.cyanAccent, width: 5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.cyanAccent, width: 5.0),
                                ),
                                labelText: "Enter the stop number",
                                labelStyle: FontBuilder.buildCommonAppThemeFont(
                                    20, Colors.white)),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ], // Only numbers can be entered
                            onSubmitted: (stopNumber) => {
                              _nextBusScheduleBloc.add(NextBusScheduleRequested(
                                  int.parse(stopNumber), null, null)),
                              FocusScope.of(context).unfocus()
                            },
                          ),
                          ElevatedButton(
                            style: style,
                            onPressed: () {
                              var stopNumber =
                                  int.parse(textFieldController.text);
                              _nextBusScheduleBloc.add(NextBusScheduleRequested(
                                  stopNumber, null, null));
                              FocusScope.of(context).unfocus();
                            },
                            child: const Text('Enter'),
                          ),
                          BlocBuilder<StopNumberSearchBloc,
                                  NextBusScheduleState>(
                              bloc: _nextBusScheduleBloc,
                              builder: (context, state) {
                                if (state is NextBusScheduleLoadInProgress) {
                                  return getLoadingScreen();
                                } else if (state
                                    is NextBusScheduleLoadSuccess) {
                                  return getNextBusSchedulesList(
                                      state.nextBusStopInfo, context);
                                } else {
                                  return Container();
                                }
                              })
                        ],
                      )))),
          FloatingMenu(onTap: () => _scaffoldKey.currentState!.openDrawer())
        ]),
        drawer: _navBar);
  }
}
