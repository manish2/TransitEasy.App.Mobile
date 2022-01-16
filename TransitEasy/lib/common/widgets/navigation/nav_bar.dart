import 'package:TransitEasy/blocs/events/pinnedstops/pinned_stops_requested.dart';
import 'package:TransitEasy/blocs/pinnedstops_bloc.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_state.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_successful.dart';
import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar_item.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBar extends StatelessWidget {
  //creates padding at top of sidenav for different viewports
  double getTopPadding(BuildContext ctx) {
    return (MediaQuery.of(ctx).size.height * 0.08).roundToDouble();
  }

  Widget getLoadingScreen() {
    return Container(
        child: SizedBox(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromRGBO(221, 160, 221, .6)),
          ),
          width: 60,
          height: 60,
        ),
        alignment: Alignment.center,
        color: appPageColor);
  }

  List<Widget> buildPinnedStopsWidgetList(
      List<StopInfoStreamModel> pinnedStopsCsv, BuildContext context) {
    var pinnedStops = pinnedStopsCsv.map((e) => ListTile(
        leading: FittedBox(
          child: Text(getPinnedStopLabel(e),
              style:
                  FontBuilder.buildCommonAppThemeFont(20, Colors.cyanAccent)),
          fit: BoxFit.cover,
        ),
        tileColor: Colors.cyanAccent,
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/pinnedstop', arguments: e);
        }));
    return ListTile.divideTiles(
            context: context, tiles: pinnedStops, color: Colors.cyanAccent)
        .toList();
  }

  String getPinnedStopLabel(StopInfoStreamModel model) =>
      "${model.stopNo}: ${model.stopName}";

  @override
  Widget build(BuildContext context) {
    var pinnedStopsBloc = BlocProvider.of<PinnedStopsBloc>(context);
    pinnedStopsBloc.add(PinnedStopsRequested());
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
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
              NavbarItem(
                  title: 'Track My Bus',
                  icon: Icons.location_pin,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pushReplacementNamed('/trackmybus');
                  }),
              NavbarItem(
                  title: 'Enter Stop Number',
                  icon: Icons.search,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context).pushReplacementNamed('/stopnumber');
                  }),
              NavbarItem(
                  title: 'Skytrain Schedules',
                  icon: Icons.train,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/skytrainschedule');
                  }),
              NavbarItem(
                  title: 'Seabus Schedules',
                  icon: Icons.directions_ferry,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/seabusschedule');
                  }),
              NavbarItem(
                  title: 'Service Alerts',
                  icon: Icons.info,
                  showDivider: true,
                  onTapListener: () {
                    Navigator.of(context)
                        .pushReplacementNamed('/servicealerts');
                  }),
              NavbarItem(
                title: 'Settings',
                icon: Icons.settings,
                showDivider: false,
                onTapListener: () {
                  Navigator.of(context).pushReplacementNamed('/settings');
                },
              ),
              Container(
                height: 30,
                color: Colors.cyanAccent,
                child: Text("Pinned Stops",
                    style: FontBuilder.buildCommonAppThemeFont(
                        20, Colors.black87)),
              ),
              BlocBuilder<PinnedStopsBloc, PinnedStopsState>(
                builder: (context, state) {
                  if (state is PinnedStopsLoadInProgress) {
                    return getLoadingScreen();
                  } else if (state is PinnedStopsSuccesful) {
                    return Column(
                        children: buildPinnedStopsWidgetList(
                            state.pinnedStops, context));
                  }
                  return Container(
                    child: Text("DIDNT WORK!!"),
                  );
                },
                bloc: pinnedStopsBloc,
              )
            ])));
  }
}
