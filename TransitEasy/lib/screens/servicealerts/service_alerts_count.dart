import 'package:flutter/material.dart';

class ServiceAlertsCount extends StatelessWidget {
  final int _count;
  ServiceAlertsCount(this._count);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: 25,
      height: 25,
      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      child: Text(
        '$_count',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
  }
}
