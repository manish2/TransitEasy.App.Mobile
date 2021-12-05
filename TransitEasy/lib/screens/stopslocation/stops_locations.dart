import 'package:TransitEasy/blocs/events/permission/permissions_requested.dart';
import 'package:TransitEasy/blocs/nextbusschedule_bloc.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/pinnedstops_bloc.dart';
import 'package:TransitEasy/blocs/schedulednotifications_bloc.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_load_success.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_state.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/clients/transiteasy_scheduler_api_client.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/models/permissiontype.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:TransitEasy/screens/stopslocation/stops_locations_layout.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopsLocationsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StopsLocationsState();
}

class _StopsLocationsState extends State<StopsLocationsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavBar _navBar = new NavBar();
  final List<PermissionType> _requiredPermissions = [PermissionType.Location];
  Widget loadWhenPermissionsReturned(
      PermissionsLoadSuccess permissions,
      StopsLocationsMapBloc mapBloc,
      NextBusScheduleBloc nextBusScheduleBloc,
      PinnedStopsBloc _pinnedStopsBloc) {
    if (!permissions.permissionValues.containsKey(PermissionType.Location) ||
        permissions.permissionValues[PermissionType.Location] != true) {
      return StopsLocationsLayout(
          mapBloc,
          nextBusScheduleBloc,
          ScheduledNotificationsBloc(TransitEasySchedulerApiClient(),
              UserSettingsRepository(SettingsService())),
          _pinnedStopsBloc);
    }
    return StopsLocationsLayout(
        mapBloc,
        nextBusScheduleBloc,
        ScheduledNotificationsBloc(TransitEasySchedulerApiClient(),
            UserSettingsRepository(SettingsService())),
        _pinnedStopsBloc);
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
    final StopsLocationsMapBloc mapBloc =
        BlocProvider.of<StopsLocationsMapBloc>(context);
    final NextBusScheduleBloc nextBusScheduleBloc =
        BlocProvider.of<NextBusScheduleBloc>(context);
    final PermissionsBloc permissionBloc =
        BlocProvider.of<PermissionsBloc>(context);
    final PinnedStopsBloc pinnedStopsBloc =
        BlocProvider.of<PinnedStopsBloc>(context);
    permissionBloc.add(PermissionsRequested(_requiredPermissions));

    return BlocBuilder<PermissionsBloc, PermissionsState>(
        bloc: permissionBloc,
        builder: (context, state) {
          if (state is PermissionsLoadSuccess) {
            return Scaffold(
              key: _scaffoldKey,
              drawer: _navBar,
              body: Stack(
                children: [
                  loadWhenPermissionsReturned(
                      state, mapBloc, nextBusScheduleBloc, pinnedStopsBloc),
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
