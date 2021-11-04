// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicles_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehiclesLocation _$VehiclesLocationFromJson(Map<String, dynamic> json) {
  return VehiclesLocation(
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    json['pattern'] as String,
    json['tripId'] as int,
    json['vehicleNo'] as String,
    json['routeNo'] as int,
    json['direction'] as String,
    VehicleRouteMapData.fromJson(json['routeMapData'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$VehiclesLocationToJson(VehiclesLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'pattern': instance.pattern,
      'tripId': instance.tripId,
      'vehicleNo': instance.vehicleNo,
      'routeNo': instance.routeNo,
      'direction': instance.direction,
      'routeMapData': instance.routeMapData.toJson(),
    };
