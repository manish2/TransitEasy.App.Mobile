import 'package:TransitEasy/common/models/nearby_stops_result.dart';
import 'package:TransitEasy/common/models/stop_info.dart';
import 'package:TransitEasy/clients/transiteasy_api_client.dart';

class TransitEasyRepository {
  final TransitEasyApiClient transityEasyApiClient;
  TransitEasyRepository(this.transityEasyApiClient);

  Future<NearbyStopsResult> getNearbyStopsInfo(
      double currLat, double currLong, int radius) async {
    return await transityEasyApiClient.getNearbyStopsInfo(
        currLat, currLong, radius);
  }
}
