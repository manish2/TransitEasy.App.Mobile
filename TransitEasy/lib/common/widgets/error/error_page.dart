import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/constants.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  ErrorPage([this.errorMessage = 'Sorry, we encountered an unexpected error!']);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            top: 24,
            bottom: 200,
            left: 24,
            right: 24,
            child: Container(
              child: Image.asset('images/brain_meditating.png'),
            ),
          ),
          Positioned(
            top: 150,
            bottom: 0,
            left: 24,
            right: 24,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'OOPS',
                  textAlign: TextAlign.center,
                  style: FontBuilder.buildCommonAppThemeFont(
                      50, Colors.cyanAccent),
                ),
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: FontBuilder.buildCommonAppThemeFont(
                      30, Colors.cyanAccent),
                ),
              ],
            ),
          )
        ],
      ),
      color: appPageColor,
    );
  }
}
