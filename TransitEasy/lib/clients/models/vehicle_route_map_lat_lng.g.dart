// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_route_map_lat_lng.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleRouteMapLatLng _$VehicleRouteMapLatLngFromJson(
    Map<String, dynamic> json) {
  return VehicleRouteMapLatLng(
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _$VehicleRouteMapLatLngToJson(
        VehicleRouteMapLatLng instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
