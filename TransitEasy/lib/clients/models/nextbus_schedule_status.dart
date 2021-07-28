import 'package:json_annotation/json_annotation.dart';

enum NextBusScheduleStatus {
  @JsonValue(0)
  ONTIME,
  @JsonValue(1)
  DELAYED,
  @JsonValue(2)
  AHEAD
}
