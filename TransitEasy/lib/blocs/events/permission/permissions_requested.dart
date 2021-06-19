import 'package:TransitEasy/blocs/events/permission/permissions_event.dart';
import 'package:TransitEasy/models/permissiontype.dart';

class PermissionsRequested extends PermissionsEvent {
  final List<PermissionType> permissionTypes;

  PermissionsRequested(this.permissionTypes);

  @override
  List<Object?> get props => [];
}
