import 'package:flutter/material.dart';

class PermissionsRequest extends StatelessWidget {
  final Function onPressed;
  final String userPrompt;
  final String buttonText;
  const PermissionsRequest(
      {Key key, this.onPressed, this.userPrompt, this.buttonText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(this.userPrompt, textAlign: TextAlign.center),
        ElevatedButton(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Text(buttonText),
            ),
            onPressed: this.onPressed)
      ],
    ));
  }
}
