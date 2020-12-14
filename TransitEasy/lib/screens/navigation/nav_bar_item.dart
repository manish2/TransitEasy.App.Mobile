import 'package:TransitEasy/constants.dart';
import 'package:flutter/material.dart';

class NavbarItem extends StatelessWidget {
  //final IconData icon;
  final String title;
  final IconData icon;
  final bool showDivider;
  const NavbarItem({Key key, this.icon, this.title, this.showDivider})
      : super(key: key);

  List<Widget> buildChildren() {
    List<Widget> builder = [
      new Opacity(
        opacity: 0.55,
        child: ListTile(
            tileColor: Colors.white,
            leading:
                SizedBox(height: 30, child: Icon(icon, color: Colors.black)),
            title: Text(
              title,
              style: appFont,
            )),
      )
    ];
    if (showDivider)
      builder.add(new Divider(
        height: 5,
      ));
    return builder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: buildChildren());
  }
}
