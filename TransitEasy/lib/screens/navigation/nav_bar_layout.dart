import 'package:TransitEasy/screens/stops_location.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavBarLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: <Widget>[StopsLocationScreen()]));
  }
}
