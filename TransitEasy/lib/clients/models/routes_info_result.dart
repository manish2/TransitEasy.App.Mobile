import 'package:TransitEasy/clients/models/api_response_status.dart';
import 'package:TransitEasy/clients/models/route_info.dart';
import 'package:json_annotation/json_annotation.dart';
part 'routes_info_result.g.dart';

@JsonSerializable(explicitToJson: true)
class RoutesInfoResult {
  @JsonKey(unknownEnumValue: ApiResponseStatus.Success)
  ApiResponseStatus responseStatus;
  List<RouteInfo>? routesInfo;

  RoutesInfoResult(this.responseStatus, this.routesInfo);

  factory RoutesInfoResult.fromJson(Map<String, dynamic> data) =>
      _$RoutesInfoResultFromJson(data);

  Map<String, dynamic> toJson() => _$RoutesInfoResultToJson(this);
}
