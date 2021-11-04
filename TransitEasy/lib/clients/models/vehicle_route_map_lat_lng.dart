import 'package:json_annotation/json_annotation.dart';

part 'vehicle_route_map_lat_lng.g.dart';

@JsonSerializable(explicitToJson: true)
class VehicleRouteMapLatLng {
  final double latitude;
  final double longitude;
  VehicleRouteMapLatLng(this.latitude, this.longitude);

  factory VehicleRouteMapLatLng.fromJson(Map<String, dynamic> json) =>
      _$VehicleRouteMapLatLngFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleRouteMapLatLngToJson(this);
}
