import 'package:json_annotation/json_annotation.dart';

enum ApiResponseStatus {
  @JsonValue(0)
  Success,
  @JsonValue(1)
  NoStopsNearLocation
}
