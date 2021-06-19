import 'dart:convert';
import 'package:TransitEasy/common/models/nearby_stops_result.dart';
import 'package:http/http.dart' as http;

class TransitEasyApiClient {
  static const baseUrl = "transiteasyapi.azurewebsites.net";

  Future<NearbyStopsResult> getNearbyStopsInfo(
      double currLat, double currLong, int radius) async {
    var uri = Uri.https(baseUrl, '/api/Stops/getnearbystops', {
      'currentLat': '$currLat',
      'currentLong': '$currLong',
      'radius': '$radius'
    });
    var nearbyStopsRespone = await http.get(uri);
    if (nearbyStopsRespone.statusCode != 200) {
      throw Exception('error getting neaby stops');
    }
    var parsedObj =
        json.decode(nearbyStopsRespone.body) as Map<String, dynamic>;
    var nearbyStopsResult = NearbyStopsResult.fromJson(parsedObj);
    return nearbyStopsResult;
  }
}
