import 'package:TransitEasy/constants.dart';
import 'package:flutter/material.dart';

class NavbarItem extends StatelessWidget {
  //final IconData icon;
  final String title;
  final IconData icon;
  final bool showDivider;
  final Function onTapListener;
  const NavbarItem(
      {Key key, this.icon, this.title, this.showDivider, this.onTapListener})
      : super(key: key);

  List<Widget> buildChildren() {
    List<Widget> builder = [
      new ListTile(
          onTap: onTapListener,
          visualDensity: VisualDensity(horizontal: 0, vertical: 0),
          //tileColor: Colors.white,
          leading: SizedBox(height: 30, child: Icon(icon, color: Colors.white)),
          title: Text(
            title,
            style: appFont,
          )),
    ];
    //if (showDivider)
    //  builder.add(new Divider(
    //     height: 5,
    //  ));
    return builder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: buildChildren());
  }
}
