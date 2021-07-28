import 'package:TransitEasy/clients/models/nextbus_schedule_status.dart';
import 'package:json_annotation/json_annotation.dart';
part 'nextbus_schedule.g.dart';

@JsonSerializable(explicitToJson: true)
class NextBusSchedule {
  bool isTripCancelled;
  bool isStopCancelled;
  int countdownInMin;
  NextBusScheduleStatus scheduleStatus;
  String destination;

  NextBusSchedule(this.isTripCancelled, this.isStopCancelled,
      this.countdownInMin, this.scheduleStatus, this.destination);

  factory NextBusSchedule.fromJson(Map<String, dynamic> data) =>
      _$NextBusScheduleFromJson(data);

  Map<String, dynamic> toJson() => _$NextBusScheduleToJson(this);
}
