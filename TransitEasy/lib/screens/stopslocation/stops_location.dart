import 'package:TransitEasy/common/services/permissions_service.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/screens/stopslocation/stops_location_layout.dart';
import 'package:flutter/material.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/permissions_request.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

class StopsLocationScreen extends StatefulWidget {
  @override
  _StopsLocationScreenState createState() => _StopsLocationScreenState();
}

class _StopsLocationScreenState extends State<StopsLocationScreen> {
  bool _isLocationPermissionEnabled = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavBar _navBar = new NavBar();
  final PermissionsService _permissionsService = new PermissionsService();

  @override
  void initState() {
    setLocationPermission();
    //
    super.initState();
  }

  void setLocationPermission() async {
    _isLocationPermissionEnabled =
        await _permissionsService.isLocationPermissionGranted();
  }

  void requestPermissions() async {
    var isLocationEnabled =
        await _permissionsService.requestLocationPermission();
    setState(() {
      _isLocationPermissionEnabled = isLocationEnabled;
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
                return StopsLocationLayout();
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

// class StopsLocationScreen extends StatelessWidget {
//   final NavBar _navBar = new NavBar();
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final PermissionsStore _permissionsStore = new PermissionsStore();
//   bool isPermissionsLoaded = false;

//   bool fetchIsLocationGranted() {
//     bool locationGranted = false;
//     return locationGranted.then((value) => locationGranted = value);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         key: _scaffoldKey,
//         body: Stack(children: <Widget>[
//           Conditional.single(context: context, conditionBuilder: (BuildContext context) => _permissionsStore.isLocationPermissionGranted().then((value) => null), widgetBuilder: widgetBuilder, fallbackBuilder: fallbackBuilder)
//           StopsLocationLayout(),
//           FloatingMenu(onTap: () => _scaffoldKey.currentState.openDrawer())
//         ]),
//         drawer: _navBar);
//   }
// }
