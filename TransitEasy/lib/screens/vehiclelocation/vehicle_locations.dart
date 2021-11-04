import 'package:TransitEasy/blocs/events/permission/permissions_requested.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_load_success.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_state.dart';
import 'package:TransitEasy/blocs/vehicle_locations_bloc.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/models/permissiontype.dart';
import 'package:TransitEasy/screens/vehiclelocation/vehicle_locations_layout.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

class VehicleLocations extends StatefulWidget {
  final PermissionsBloc _permissionBloc;
  final int? stopNo;
  final String? routeNo;

  VehicleLocations(this._permissionBloc, this.stopNo, this.routeNo) {
    _permissionBloc.add(PermissionsRequested([PermissionType.Location]));
  }

  @override
  State<StatefulWidget> createState() =>
      _VehicleLocations(_permissionBloc, stopNo, routeNo);
}

class _VehicleLocations extends State<VehicleLocations> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavBar _navBar = new NavBar();
  final PermissionsBloc _permissionBloc;
  final int? stopNo;
  final String? routeNo;
  _VehicleLocations(this._permissionBloc, this.stopNo, this.routeNo) {
    _permissionBloc.add(PermissionsRequested([PermissionType.Location]));
  }

  Widget loadWhenPermissionsReturned(PermissionsLoadSuccess permissions) {
    if (!permissions.permissionValues.containsKey(PermissionType.Location) ||
        permissions.permissionValues[PermissionType.Location] != true) {
      return Container();
    }
    return VehicleLocationLayout(stopNo, routeNo);
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionsBloc, PermissionsState>(
        bloc: _permissionBloc,
        builder: (context, state) {
          if (state is PermissionsLoadSuccess) {
            return Scaffold(
              key: _scaffoldKey,
              drawer: _navBar,
              body: Stack(
                children: [
                  loadWhenPermissionsReturned(state),
                  FloatingMenu(
                      onTap: () => _scaffoldKey.currentState!.openDrawer())
                ],
              ),
            );
          } else {
            return getLoadingScreen();
          }
        });
  }
}
