import 'dart:async';
import 'package:TransitEasy/common/services/locations_services.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/common/widgets/permissions_request.dart';
import 'package:TransitEasy/screens/settings/edit_stops/edit_stops_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:geolocator/geolocator.dart';

class EditStopsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EditStopsScreenState();
}

class _EditStopsScreenState extends State<EditStopsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final LocationService _locationService = LocationService();
  final NavBar _navBar = new NavBar();

  bool _isLocationPermissionEnabled = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _locationService.isLocationServiceEnabled().then((value) => {
            setState(() {
              _isLocationPermissionEnabled = value;
            })
          });
    });
    super.initState();
  }

  void requestPermissions() async {
    var locationEnabled = await _locationService.requestLocationPermission();
    setState(() {
      _isLocationPermissionEnabled =
          locationEnabled != LocationPermission.denied &&
              locationEnabled != LocationPermission.deniedForever;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: Stack(children: <Widget>[
          Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) =>
                  _isLocationPermissionEnabled,
              widgetBuilder: (BuildContext context) {
                return EditStopsLayout();
              },
              fallbackBuilder: (BuildContext context) {
                return PermissionsRequest(
                  onPressed: () {
                    requestPermissions();
                  },
                  userPrompt:
                      "TransitEasy requires you to enable location permission to use maps feature",
                  buttonText: "Enable Location",
                );
              }),
          FloatingMenu(onTap: () => _scaffoldKey.currentState.openDrawer())
        ]),
        drawer: _navBar);
  }
}
