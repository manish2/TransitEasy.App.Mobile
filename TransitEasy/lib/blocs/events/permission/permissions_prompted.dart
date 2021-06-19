import 'package:TransitEasy/blocs/events/permission/permissions_event.dart';
import 'package:TransitEasy/models/permissiontype.dart';

class PermissionsPrompted extends PermissionsEvent {
  final List<PermissionType> permissionTypes;

  PermissionsPrompted(this.permissionTypes);

  @override
  List<Object?> get props => [];
}
