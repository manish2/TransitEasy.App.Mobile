import 'package:TransitEasy/clients/models/vehicle_route_map_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicles_location.g.dart';

@JsonSerializable(explicitToJson: true)
class VehiclesLocation {
  double latitude;
  double longitude;
  String pattern;
  int tripId;
  String vehicleNo;
  int routeNo;
  String direction;
  VehicleRouteMapData routeMapData;

  VehiclesLocation(this.latitude, this.longitude, this.pattern, this.tripId,
      this.vehicleNo, this.routeNo, this.direction, this.routeMapData);

  factory VehiclesLocation.fromJson(Map<String, dynamic> data) =>
      _$VehiclesLocationFromJson(data);

  Map<String, dynamic> toJson() => _$VehiclesLocationToJson(this);
}
