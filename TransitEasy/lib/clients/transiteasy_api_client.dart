import 'dart:convert';
import 'package:TransitEasy/clients/models/nearby_stops_result.dart';
import 'package:TransitEasy/clients/models/nextbus_schedule_result.dart';
import 'package:TransitEasy/clients/models/service_alert_result.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class TransitEasyApiClient {
  static const baseUrl = "transiteasyapi2.azurewebsites.net";

  Future<NearbyStopsResult> getNearbyStopsInfo(
      double currLat, double currLong, int radius) async {
    var uri = Uri.https(baseUrl, '/api/Stops/getnearbystops', {
      'currentLat': '$currLat',
      'currentLong': '$currLong',
      'radius': '$radius'
    });
    var nearbyStopsResponse =
        await http.get(uri).timeout(const Duration(seconds: 5));
    developer.log('response from $uri \n' + nearbyStopsResponse.body,
        name: 'transiteasy.clients.transiteasy_api_client');
    if (nearbyStopsResponse.statusCode != 200) {
      throw Exception('error getting neaby stops');
    }
    var parsedObj =
        json.decode(nearbyStopsResponse.body) as Map<String, dynamic>;
    var nearbyStopsResult = NearbyStopsResult.fromJson(parsedObj);
    return nearbyStopsResult;
  }

  Future<NextBusScheduleResult> getNextBusSchedules(
      int stopNum, int numBuses) async {
    var uri = Uri.https(baseUrl, '/api/Stops/getnextbusschedules',
        {'stopNumber': '$stopNum', 'numNextBuses': '$numBuses'});
    var nextBusSchedulesResponse =
        await http.get(uri).timeout(const Duration(seconds: 5));
    developer.log('response from $uri \n' + nextBusSchedulesResponse.body,
        name: 'transiteasy.clients.transiteasy_api_client');
    if (nextBusSchedulesResponse.statusCode != 200) {
      throw Exception('error getting next bus schedules');
    }
    var parsedObj =
        json.decode(nextBusSchedulesResponse.body) as Map<String, dynamic>;
    var nextBusSchedulesResult = NextBusScheduleResult.fromJson(parsedObj);
    return nextBusSchedulesResult;
  }

  Future<ServiceAlertResult> getServiceAlerts() async {
    var uri = Uri.https(baseUrl, '/api/ServiceAlerts/servicealerts');
    var serviceAlertsResponse = await http.get(uri).timeout(const Duration(seconds: 5)); 
    developer.log('response from $uri \n' + serviceAlertsResponse.body, name: 'transiteasy.clients.transiteasy_api_client');

    if(serviceAlertsResponse.statusCode != 200) {
      throw Exception('error getting service alerts'); 
    }
    var parsedObj = json.decode(serviceAlertsResponse.body) as Map<String, dynamic>;
    var serviceAlertsResult = ServiceAlertResult.fromJson(parsedObj); 
    return serviceAlertsResult; 
  }
}
