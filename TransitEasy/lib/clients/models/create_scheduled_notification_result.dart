import 'package:json_annotation/json_annotation.dart';
part 'create_scheduled_notification_result.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateScheduledNotificationResult {
  String message;
  CreateScheduledNotificationResult(this.message);

  factory CreateScheduledNotificationResult.fromJson(
          Map<String, dynamic> data) =>
      _$CreateScheduledNotificationResultFromJson(data);

  Map<String, dynamic> toJson() =>
      _$CreateScheduledNotificationResultToJson(this);
}
