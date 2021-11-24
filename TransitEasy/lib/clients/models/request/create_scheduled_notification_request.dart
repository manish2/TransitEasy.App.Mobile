import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class CreateScheduledNotificationRequest {
  final String expectedLeaveTime;
  final int scheduleReminderInMin;
  final String fireBaseDeviceToken;
  final String routeNo;
  final String destination;
  final String stopNo;
  final int numberOfNextBuses;

  CreateScheduledNotificationRequest(
      this.expectedLeaveTime,
      this.scheduleReminderInMin,
      this.fireBaseDeviceToken,
      this.routeNo,
      this.destination,
      this.stopNo,
      this.numberOfNextBuses);
}
