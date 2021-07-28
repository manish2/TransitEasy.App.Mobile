import 'package:TransitEasy/clients/models/api_response_status.dart';
import 'package:TransitEasy/clients/models/nextbus_stop_info.dart';
import 'package:json_annotation/json_annotation.dart';
part 'nextbus_schedule_result.g.dart';

@JsonSerializable(explicitToJson: true)
class NextBusScheduleResult {
  @JsonKey(unknownEnumValue: ApiResponseStatus.Success)
  ApiResponseStatus responseStatus;
  List<NextBusStopInfo>? nextBusStopInfo;

  NextBusScheduleResult(this.responseStatus, this.nextBusStopInfo);

  factory NextBusScheduleResult.fromJson(Map<String, dynamic> data) =>
      _$NextBusScheduleResultFromJson(data);

  Map<String, dynamic> toJson() => _$NextBusScheduleResultToJson(this);
}
