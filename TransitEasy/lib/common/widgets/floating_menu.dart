import 'package:flutter/material.dart';

class FloatingMenu extends StatelessWidget {
  final Function onTap;

  const FloatingMenu({Key key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -10,
      top: 50,
      child: RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Colors.white,
          elevation: 2.0,
          child: IconButton(
            icon: Icon(Icons.menu, size: 30, color: Colors.black),
            onPressed: onTap,
          ),
          onPressed: onTap),
    );
  }
}
