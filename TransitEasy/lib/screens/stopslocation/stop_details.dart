import 'package:TransitEasy/clients/models/stop_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopDetails extends StatelessWidget {
  final StopInfo stopInfo;
  StopDetails(this.stopInfo);

  String _getStopRoutesText(StopInfo stopInfo) => stopInfo.routes.isEmpty
      ? "No routes currently servicing this stop"
      : stopInfo.routes.join(',');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Stop Number: ${stopInfo.stopNo}",
          ),
          SizedBox(
            height: 20,
          ),
          Text("Stop Name: ${stopInfo.stopName}"),
          SizedBox(
            height: 20,
          ),
          Text("Distance from you: ${stopInfo.distance} meters"),
          SizedBox(
            height: 20,
          ),
          Text(
              "Routes currently servicing this stop: ${_getStopRoutesText(stopInfo)}")
        ],
      ),
    );
  }
}
