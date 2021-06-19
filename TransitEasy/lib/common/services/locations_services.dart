import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> isLocationServiceEnabled() =>
      Geolocator.isLocationServiceEnabled();

  Future<bool> isLocationPermissionEnabled() =>
      Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> requestLocationPermission() =>
      Geolocator.requestPermission();

  Future<Position> getCurrentUserPosition() => Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true);
}
