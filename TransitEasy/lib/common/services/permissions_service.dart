import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  Future<bool> isLocationPermissionGranted() async {
    return await Permission.location.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    return await Permission.location.request().isGranted;
  }
}
