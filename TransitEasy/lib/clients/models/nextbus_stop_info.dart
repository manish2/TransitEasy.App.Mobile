import 'package:TransitEasy/clients/models/nextbus_schedule.dart';
import 'package:json_annotation/json_annotation.dart';
part 'nextbus_stop_info.g.dart';

@JsonSerializable(explicitToJson: true)
class NextBusStopInfo {
  String routeDescription;
  String direction;
  List<NextBusSchedule> schedules;

  NextBusStopInfo(this.routeDescription, this.direction, this.schedules);

  factory NextBusStopInfo.fromJson(Map<String, dynamic> data) =>
      _$NextBusStopInfoFromJson(data);

  Map<String, dynamic> toJson() => _$NextBusStopInfoToJson(this);
}
