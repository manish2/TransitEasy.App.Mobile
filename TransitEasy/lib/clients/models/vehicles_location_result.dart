import 'package:TransitEasy/clients/models/vehicles_location.dart';
import 'package:json_annotation/json_annotation.dart';
import 'api_response_status.dart';

part 'vehicles_location_result.g.dart';

@JsonSerializable(explicitToJson: true)
class VehiclesLocationResult {
  @JsonKey(unknownEnumValue: ApiResponseStatus.Success)
  ApiResponseStatus responseStatus;
  List<VehiclesLocation> vehicleLocations;
  VehiclesLocationResult(this.responseStatus, this.vehicleLocations);

  factory VehiclesLocationResult.fromJson(Map<String, dynamic> json) =>
      _$VehiclesLocationResultFromJson(json);
  Map<String, dynamic> toJson() => _$VehiclesLocationResultToJson(this);
}
