import 'package:TransitEasy/clients/models/nearby_stops_result.dart';
import 'package:TransitEasy/clients/models/nextbus_schedule_result.dart';
import 'package:TransitEasy/clients/transiteasy_api_client.dart';

class TransitEasyRepository {
  final TransitEasyApiClient transityEasyApiClient;
  TransitEasyRepository(this.transityEasyApiClient);

  Future<NearbyStopsResult> getNearbyStopsInfo(
      double currLat, double currLong, int radius) async {
    return await transityEasyApiClient.getNearbyStopsInfo(
        currLat, currLong, radius);
  }

  Future<NextBusScheduleResult> getNextBusSchedules(
      int stopNumber, int numNextBuses) async {
    return await transityEasyApiClient.getNextBusSchedules(
        stopNumber, numNextBuses);
  }
}
