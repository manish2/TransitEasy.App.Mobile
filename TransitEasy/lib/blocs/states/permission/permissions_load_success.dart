import 'package:TransitEasy/blocs/states/permission/permissions_state.dart';
import 'package:TransitEasy/models/permissiontype.dart';

class PermissionsLoadSuccess extends PermissionsState {
  final Map<PermissionType, bool> permissionValues;

  PermissionsLoadSuccess(this.permissionValues);
}
