import 'package:geolocator/geolocator.dart';

class GeoLocationService {
  Future<Position> getCurrentUserGeoLocation() async =>
      await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);

  Future<bool> getIsUserGeoLocationEnabled() async =>
      await Geolocator.isLocationServiceEnabled();

  Future<LocationPermission> requestUserGeoLocationPermission() async =>
      await Geolocator.requestPermission();
}
