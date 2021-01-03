import 'dart:async';
import 'package:TransitEasy/screens/navigation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';

class StopsLocationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StopsLocationScreenState();
}

class _StopsLocationScreenState extends State<StopsLocationScreen> {
  final NavBar _navBar = new NavBar();
  Completer<GoogleMapController> _controller = Completer();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  static final CameraPosition _myLocation =
      CameraPosition(target: LatLng(49.104599, -122.823509), zoom: 12.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: Stack(children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            zoomControlsEnabled: true,
            initialCameraPosition: _myLocation,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          FloatingMenu(onTap: () => _scaffoldKey.currentState.openDrawer())
        ]),
        drawer: _navBar);
  }
}
