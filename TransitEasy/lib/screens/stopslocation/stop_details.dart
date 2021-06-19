import 'package:TransitEasy/common/models/stop_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopDetails extends StatelessWidget {
  final StopInfo stopInfo;
  StopDetails(this.stopInfo);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Text("Stop Number: ${stopInfo.stopNo}"),
          Text("Stop Name: ${stopInfo.stopName}"),
          Text("Distance from you: ${stopInfo.distance}"),
          Text("Routes: ${stopInfo.routes.join(',')}")
        ],
      ),
    );
  }
}
