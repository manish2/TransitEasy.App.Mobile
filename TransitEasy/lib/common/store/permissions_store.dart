import 'package:permission_handler/permission_handler.dart';

class PermissionsStore {
  Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }
}
