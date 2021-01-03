import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:flutter/material.dart';
import 'package:TransitEasy/screens/navigation/nav_bar.dart';

class SettingsScreen extends StatelessWidget {
  final NavBar _navBar = new NavBar();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: Stack(children: <Widget>[
          FloatingMenu(onTap: () => _scaffoldKey.currentState.openDrawer())
        ]),
        drawer: _navBar);
  }
}
