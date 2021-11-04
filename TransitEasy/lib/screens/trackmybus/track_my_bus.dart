import 'package:TransitEasy/blocs/busrouteslist_bloc.dart';
import 'package:TransitEasy/blocs/events/busrouteslist/busroutes_requested.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_load_success.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_state.dart';
import 'package:TransitEasy/common/widgets/error/error_page.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/vehiclelocation/vehicle_locations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackMyBusScreen extends StatelessWidget {
  final BusRoutesListBloc _busRoutesListBloc;
  final PermissionsBloc _permissionsBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavBar _navBar = new NavBar();

  TrackMyBusScreen(this._busRoutesListBloc, this._permissionsBloc);

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

  Widget buildLayoutFromState(BusRoutesState state, BuildContext context) {
    if (state is BusRoutesLoadInProgress) {
      return getLoadingScreen();
    } else if (state is BusRoutesLoadSuccess) {
      return Container(
        child: ListView(
          children: state.routesInfo
              .map((e) => ListTile(
                    leading: FittedBox(
                      child: Text(e.routeShortName + "-" + e.routeLongName),
                      fit: BoxFit.cover,
                    ),
                    tileColor: Colors.cyanAccent,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  VehicleLocations(_permissionsBloc, null,
                                      e.routeShortName)));
                    },
                  ))
              .toList(),
        ),
        padding: EdgeInsets.only(top: 60),
      );
    } else {
      return ErrorPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    _busRoutesListBloc.add(BusRoutesRequested());
    return BlocBuilder<BusRoutesListBloc, BusRoutesState>(
      bloc: _busRoutesListBloc,
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: _navBar,
          body: Stack(
            children: [
              buildLayoutFromState(state, context),
              FloatingMenu(onTap: () => _scaffoldKey.currentState!.openDrawer())
            ],
          ),
        );
      },
    );
  }
}
