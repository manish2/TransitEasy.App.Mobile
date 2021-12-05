import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:flutter/material.dart';

class NavbarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool showDivider;
  final Function() onTapListener;
  const NavbarItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.showDivider,
      required this.onTapListener})
      : super(key: key);

  List<Widget> buildChildren() {
    List<Widget> builder = [
      new InkWell(
        onTap: onTapListener,
        highlightColor: Color.fromRGBO(221, 160, 221, .8),
        splashColor: Color.fromRGBO(221, 160, 221, .8),
        child: new ListTile(
            onTap: onTapListener,
            visualDensity: VisualDensity(horizontal: 0, vertical: 0),
            leading: SizedBox(
                height: 30, child: Icon(icon, color: Colors.cyanAccent)),
            title: Text(
              title,
              style: FontBuilder.buildCommonAppThemeFont(20, Colors.cyanAccent),
            )),
      )
    ];
    return builder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: buildChildren());
  }
}
