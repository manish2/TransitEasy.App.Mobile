import 'dart:async';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopsLocationLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StopsLocationLayoutState();
}

class StopsLocationLayoutState extends State<StopsLocationLayout> {
  final NavBar _navBar = new NavBar();
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _myLocation =
      CameraPosition(target: LatLng(49.104599, -122.823509), zoom: 12.0);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: true,
        initialCameraPosition: _myLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      )
    ]);
  }
}
