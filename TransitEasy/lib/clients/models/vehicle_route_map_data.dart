import 'package:TransitEasy/clients/models/vehicle_route_map_lat_lng.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_route_map_data.g.dart';

@JsonSerializable(explicitToJson: true)
class VehicleRouteMapData {
  final List<List<VehicleRouteMapLatLng>> coordinateData;
  VehicleRouteMapData(this.coordinateData);

  factory VehicleRouteMapData.fromJson(Map<String, dynamic> json) =>
      _$VehicleRouteMapDataFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleRouteMapDataToJson(this);
}
