import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar_item.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  //creates padding at top of sidenav for different viewports
  double getTopPadding(BuildContext ctx) {
    return (MediaQuery.of(ctx).size.height * 0.08).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(51, 0, 123, .95),
            ),
            padding: EdgeInsets.only(top: getTopPadding(context)),
            child: ListView(padding: EdgeInsets.zero, children: <Widget>[
              NavbarItem(
                title: 'Stops near me',
                icon: Icons.bus_alert,
                showDivider: true,
                onTapListener: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/');
                },
              ),
              NavbarItem(
                  title: 'Track My Bus',
                  icon: Icons.location_pin,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/trackmybus');
                  }),
              NavbarItem(
                  title: 'Enter Stop Number',
                  icon: Icons.search,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/stopnumber');
                  }),
              NavbarItem(
                  title: 'Skytrain Schedules',
                  icon: Icons.train,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/skytrainschedule');
                  }),
              NavbarItem(
                  title: 'Seabus Schedules',
                  icon: Icons.directions_ferry,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/seabusschedule');
                  }),
              NavbarItem(
                  title: 'Service Alerts',
                  icon: Icons.info,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/servicealerts');
                  }),
              NavbarItem(
                title: 'Settings',
                icon: Icons.settings,
                showDivider: false,
                onTapListener: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/settings');
                },
              ),
              Container(
                height: 30,
                color: Colors.cyanAccent,
                child: Text("Pinned Stops",
                    style: FontBuilder.buildCommonAppThemeFont(
                        20, Colors.black87)),
              ),
            ])));
  }
}
