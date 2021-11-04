import 'package:TransitEasy/blocs/busrouteslist_bloc.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/servicealerts_bloc.dart';
import 'package:TransitEasy/blocs/stopnumbersearch_bloc.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar_item.dart';
import 'package:TransitEasy/screens/servicealerts/service_alerts.dart';
import 'package:TransitEasy/screens/settings/settings.dart';
import 'package:TransitEasy/screens/stopnumbersearch/stopnumbersearch.dart';
import 'package:TransitEasy/screens/stopslocation/stops_locations.dart';
import 'package:TransitEasy/screens/trackmybus/track_my_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class NavBar extends StatelessWidget {
  //creates padding at top of sidenav for different viewports
  double getTopPadding(BuildContext ctx) {
    return (MediaQuery.of(ctx).size.height * 0.08).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final StopNumberSearchBloc _stopNumberSearchBloc =
        BlocProvider.of<StopNumberSearchBloc>(context);
    final ServiceAlertsBloc _serviceAlertsBloc =
        BlocProvider.of<ServiceAlertsBloc>(context);
    final BusRoutesListBloc _busRoutesListBloc =
        BlocProvider.of<BusRoutesListBloc>(context);
    final PermissionsBloc _permissionBloc =
        BlocProvider.of<PermissionsBloc>(context);
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
                  Navigator.pop(context);
                  developer.log("CAN POP STOPS NEAR ME: " +
                      Navigator.canPop(context).toString());
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new StopsLocationsScreen()));
                },
              ),
              NavbarItem(
                  title: 'Track My Bus',
                  icon: Icons.location_pin,
                  showDivider: true,
                  onTapListener: () {
                    developer.log("CAN POP Track My Bus: " +
                        Navigator.of(context).canPop().toString());
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) => TrackMyBusScreen(
                                _busRoutesListBloc, _permissionBloc)));
                  }),
              NavbarItem(
                  title: 'Enter Stop Number',
                  icon: Icons.search,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                StopNumberSearchScreen(_stopNumberSearchBloc)));
                  }),
              NavbarItem(
                  title: 'Bus Schedules',
                  icon: Icons.directions_bus,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Skytrain Schedules',
                  icon: Icons.train,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Seabus Schedules',
                  icon: Icons.directions_ferry,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Traffic Updates',
                  icon: Icons.traffic,
                  showDivider: true,
                  onTapListener: () {}),
              NavbarItem(
                  title: 'Service Alerts',
                  icon: Icons.info,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new ServiceAlertsScreen(_serviceAlertsBloc)));
                  }),
              NavbarItem(
                title: 'Settings',
                icon: Icons.settings,
                showDivider: false,
                onTapListener: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new SettingsScreen()));
                },
              ),
            ])));
  }
}
