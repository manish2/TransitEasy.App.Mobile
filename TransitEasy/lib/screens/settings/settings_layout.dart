import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/screens/settings/edit_alerts/edit_alerts.dart';
import 'package:TransitEasy/screens/settings/edit_bus_location/edit_bus_location.dart';
import 'package:TransitEasy/screens/settings/edit_stops/edit_stops.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class SettingsLayout extends StatelessWidget {
  static Route<void> _editAlertsBuilder(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
        context: context,
        builder: (BuildContext context) => const EditAlertsScreen(),
        barrierColor: appPageColor);
  }

  static Route<void> _editBusLocationBuild(
      BuildContext context, Object? arguments) {
    return DialogRoute<void>(
        context: context,
        builder: (BuildContext context) => const EditBusLocationScreen(),
        barrierColor: appPageColor);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(51, 0, 123, .95),
        ),
        padding: EdgeInsets.only(top: 80.0),
        child: ListView(children: [
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Color.fromRGBO(221, 160, 221, .6),
              child: ListTile(
                title: Text(
                  "Edit default stops search radius",
                  style: FontBuilder.buildCommonAppThemeFont(18, Colors.white),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new EditStopsScreen()));
                },
              )),
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Color.fromRGBO(221, 160, 221, .6),
              child: ListTile(
                title: Text(
                  "Edit when to alert me about my bus",
                  style: FontBuilder.buildCommonAppThemeFont(18, Colors.white),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.restorablePush(context, _editAlertsBuilder);
                },
              )),
          Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Color.fromRGBO(221, 160, 221, .6),
              child: ListTile(
                title: Text(
                  "Edit bus location refresh interval",
                  style: FontBuilder.buildCommonAppThemeFont(18, Colors.white),
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.restorablePush(context, _editBusLocationBuild);
                },
              ))
        ]));
  }
}
