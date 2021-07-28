import 'package:TransitEasy/clients/models/stop_info.dart';
import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/constants.dart';
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
            style: FontBuilder.buildCommonAppThemeFont(16, Colors.cyanAccent),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Stop Name: ${stopInfo.stopName}",
            style: FontBuilder.buildCommonAppThemeFont(16, Colors.cyanAccent),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Distance from you: ${stopInfo.distance} meters",
            style: FontBuilder.buildCommonAppThemeFont(16, Colors.cyanAccent),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Routes currently servicing this stop: ${_getStopRoutesText(stopInfo)}",
            style: FontBuilder.buildCommonAppThemeFont(16, Colors.cyanAccent),
          )
        ],
      ),
      backgroundColor: appPageColor,
    );
  }
}
