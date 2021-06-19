import 'package:TransitEasy/models/userlocation.dart';
import 'package:TransitEasy/services/geolocation_service.dart';

class UserLocationRepository {
  final GeoLocationService geoLocationService;
  UserLocationRepository(this.geoLocationService);

  Future<UserLocation> getCurrentUserLocation() async {
    var currentPosition = await geoLocationService.getCurrentUserGeoLocation();
    return UserLocation(currentPosition.latitude, currentPosition.longitude);
  }

  Future<bool> getIsUserLocationEnabled() async =>
      await geoLocationService.getIsUserGeoLocationEnabled();
}
