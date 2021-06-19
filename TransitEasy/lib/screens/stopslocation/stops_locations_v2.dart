import 'package:TransitEasy/blocs/events/permission/permissions_requested.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_load_success.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_state.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/models/permissiontype.dart';
import 'package:TransitEasy/screens/stopslocation/stops_locations_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopsLocationsV2 extends StatelessWidget {
  final List<PermissionType> _requiredPermissions = [PermissionType.Location];
  Widget loadWhenPermissionsReturned(
      PermissionsLoadSuccess permissions, StopsLocationsMapBloc mapBloc) {
    if (!permissions.permissionValues.containsKey(PermissionType.Location) ||
        permissions.permissionValues[PermissionType.Location] != true) {
      return StopsLocationsLayout(mapBloc);
    }
    return StopsLocationsLayout(mapBloc);
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
    final PermissionsBloc permissionBloc =
        BlocProvider.of<PermissionsBloc>(context);
    final StopsLocationsMapBloc mapBloc =
        BlocProvider.of<StopsLocationsMapBloc>(context);
    permissionBloc.add(PermissionsRequested(_requiredPermissions));

    return BlocBuilder<PermissionsBloc, PermissionsState>(
        bloc: permissionBloc,
        builder: (context, state) {
          if (state is PermissionsLoadSuccess) {
            return loadWhenPermissionsReturned(state, mapBloc);
          } else {
            return getLoadingScreen();
          }
        });
  }
}
