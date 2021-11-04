import 'package:flutter/material.dart';

class PermissionsErrorPage extends StatelessWidget {
  PermissionsErrorPage();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
            "Sorry, you need to enable the correct permission to use this feature, please click below to enable them"));
  }
}
