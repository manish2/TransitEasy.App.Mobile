import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StopDetailsV2 extends StatelessWidget {
  final StopInfoStreamModel stopInfo;
  StopDetailsV2(this.stopInfo);

  String _getStopRoutesText(StopInfoStreamModel stopInfo) =>
      stopInfo.routes != null && stopInfo.routes!.isEmpty
          ? "No routes currently servicing this stop"
          : stopInfo.routes!.join(',');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.51),
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
