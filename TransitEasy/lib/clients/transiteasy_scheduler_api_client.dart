import 'dart:convert';

import 'package:TransitEasy/clients/models/create_scheduled_notification_result.dart';
import 'package:TransitEasy/clients/models/request/create_scheduled_notification_request.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class TransitEasySchedulerApiClient {
  static const baseUrl = "transiteasyscheduler.azurewebsites.net";

  Future<CreateScheduledNotificationResult?> scheduleNotification(
      CreateScheduledNotificationRequest request) async {
    var uri = Uri.https(baseUrl, '/createschedulednotification');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var jsonBody = json.encode({
      'expectedLeaveTime': request.expectedLeaveTime,
      'scheduleReminderInMin': request.scheduleReminderInMin,
      'fireBaseDeviceToken': request.fireBaseDeviceToken,
      'routeNo': request.routeNo,
      'destination': request.destination,
      'stopNo': request.stopNo,
      'numberOfNextBuses': request.numberOfNextBuses,
    });

    var result = await http.post(uri, body: jsonBody, headers: headers);

    developer.log('response from $uri \n' + result.body,
        name: 'transiteasy.clients.transiteasy_scheduler_api_client');

    if (result.statusCode == 201 || result.statusCode == 200) {
      var parsedResult = json.decode(result.body) as Map<String, dynamic>;
      return CreateScheduledNotificationResult.fromJson(parsedResult);
    }

    return null;
  }
}
