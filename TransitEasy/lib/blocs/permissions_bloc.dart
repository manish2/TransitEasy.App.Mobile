import 'package:TransitEasy/blocs/events/permission/permissions_event.dart';
import 'package:TransitEasy/blocs/events/permission/permissions_prompted.dart';
import 'package:TransitEasy/blocs/events/permission/permissions_requested.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_initial.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_load_success.dart';
import 'package:TransitEasy/blocs/states/permission/permissions_state.dart';
import 'package:TransitEasy/models/permissiontype.dart';
import 'package:TransitEasy/services/geolocation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class PermissionsBloc extends Bloc<PermissionsEvent, PermissionsState> {
  final GeoLocationService geoLocationService;
//
  PermissionsBloc(this.geoLocationService) : super(PermissionsInitial());

  @override
  Stream<PermissionsState> mapEventToState(PermissionsEvent event) async* {
    yield PermissionsLoadInProgress();
    Map<PermissionType, bool> permissionValues =
        new Map<PermissionType, bool>();
    if (event is PermissionsRequested) {
      await Future.forEach<PermissionType>(event.permissionTypes,
          (element) async {
        var value = await getPermissionValueAsync(element);
        permissionValues[element] = value;
      });
    } else if (event is PermissionsPrompted) {
      await Future.forEach<PermissionType>(event.permissionTypes,
          (element) async {
        var value = await promptPermission(element);
        permissionValues[element] = value;
      });
    }
    yield PermissionsLoadSuccess(permissionValues);
  }

  Future<bool> promptPermission(PermissionType permissionType) async {
    if (permissionType == PermissionType.Location) {
      var result = await geoLocationService.requestUserGeoLocationPermission();
      return result == LocationPermission.always ||
          result == LocationPermission.whileInUse;
    }
    return false;
  }

  Future<bool> getPermissionValueAsync(PermissionType permissionType) async {
    if (permissionType == PermissionType.Location) {
      return await geoLocationService.getIsUserGeoLocationEnabled();
    } else {
      throw Exception(
          "Enum type ${permissionType.toString()} is not supported");
    }
  }
}
