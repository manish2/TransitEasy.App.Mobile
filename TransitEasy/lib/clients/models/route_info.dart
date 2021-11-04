import 'package:json_annotation/json_annotation.dart';
part 'route_info.g.dart';

@JsonSerializable(explicitToJson: true)
class RouteInfo {
  int routeId;
  String routeShortName;
  String routeLongName;

  RouteInfo(this.routeId, this.routeShortName, this.routeLongName);

  factory RouteInfo.fromJson(Map<String, dynamic> data) =>
      _$RouteInfoFromJson(data);

  Map<String, dynamic> toJson() => _$RouteInfoToJson(this);
}
