import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:flutter/material.dart';

class ServiceAlertCard extends StatelessWidget {
  final String _alertHeader;
  final String _alertDescription;

  ServiceAlertCard(this._alertHeader, this._alertDescription);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(
            this._alertHeader,
            style: FontBuilder.buildCommonAppThemeFont(15, Colors.black),
          ),
          Text(
            this._alertDescription,
            style: FontBuilder.buildCommonAppThemeFont(15, Colors.black),
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
