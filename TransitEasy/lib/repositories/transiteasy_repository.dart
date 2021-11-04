import 'package:TransitEasy/clients/models/nearby_stops_result.dart';
import 'package:TransitEasy/clients/models/nextbus_schedule_result.dart';
import 'package:TransitEasy/clients/models/routes_info_result.dart';
import 'package:TransitEasy/clients/models/service_alert_result.dart';
import 'package:TransitEasy/clients/transiteasy_api_client.dart';

class TransitEasyRepository {
  final TransitEasyApiClient _transityEasyApiClient;
  TransitEasyRepository(this._transityEasyApiClient);

  Future<NearbyStopsResult> getNearbyStopsInfo(
      double currLat, double currLong, int radius) async {
    return await _transityEasyApiClient.getNearbyStopsInfo(
        currLat, currLong, radius);
  }

  Future<NextBusScheduleResult> getNextBusSchedules(
      int stopNumber, int numNextBuses) async {
    return await _transityEasyApiClient.getNextBusSchedules(
        stopNumber, numNextBuses);
  }

  Future<ServiceAlertResult> getServiceAlerts() async {
    return await _transityEasyApiClient.getServiceAlerts();
  }

  Future<RoutesInfoResult> getRoutes() async {
    return await _transityEasyApiClient.getRoutes();
  }
}
