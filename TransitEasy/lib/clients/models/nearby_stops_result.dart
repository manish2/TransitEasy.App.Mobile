import 'package:TransitEasy/clients/models/api_response_status.dart';
import 'package:TransitEasy/clients/models/stop_info.dart';
import 'package:json_annotation/json_annotation.dart';
part 'nearby_stops_result.g.dart';

@JsonSerializable(explicitToJson: true)
class NearbyStopsResult {
  @JsonKey(unknownEnumValue: ApiResponseStatus.Success)
  ApiResponseStatus responseStatus;
  List<StopInfo>? nearbyStopsInfo;

  NearbyStopsResult(this.responseStatus, this.nearbyStopsInfo);

  factory NearbyStopsResult.fromJson(Map<String, dynamic> data) =>
      _$NearbyStopsResultFromJson(data);

  Map<String, dynamic> toJson() => _$NearbyStopsResultToJson(this);
}
