import 'dart:convert';

import 'package:TransitEasy/common/models/api_response_status.dart';
import 'package:TransitEasy/common/models/nearby_stops_result.dart';
import 'package:TransitEasy/common/models/stop_info.dart';
import 'package:TransitEasy/common/models/stops_location.dart';
import 'package:http/http.dart' as http;

class StopsApiService {
  final String _translinkApi = "transiteasyapi.azurewebsites.net";

  Future<List<StopInfo>?> getAllClosestStopLocations(
      double currLat, double currLong, int radius) async {
    var uri = Uri.https(_translinkApi, '/api/Stops/getnearbystops', {
      'currentLat': '$currLat',
      'currentLong': '$currLong',
      'radius': '$radius'
    });
    var response = await http.get(uri);
    var parsedObj = json.decode(response.body) as Map<String, dynamic>;
    var nearbyStopsResult = NearbyStopsResult.fromJson(parsedObj);
    if (nearbyStopsResult.responseStatus ==
        ApiResponseStatus.NoStopsNearLocation) {
      return [];
    }
    return nearbyStopsResult.nearbyStopsInfo;
  }
}
