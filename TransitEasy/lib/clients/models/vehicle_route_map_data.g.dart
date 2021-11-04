// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_route_map_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleRouteMapData _$VehicleRouteMapDataFromJson(Map<String, dynamic> json) {
  return VehicleRouteMapData(
    (json['coordinateData'] as List<dynamic>)
        .map((e) => (e as List<dynamic>)
            .map((e) =>
                VehicleRouteMapLatLng.fromJson(e as Map<String, dynamic>))
            .toList())
        .toList(),
  );
}

Map<String, dynamic> _$VehicleRouteMapDataToJson(
        VehicleRouteMapData instance) =>
    <String, dynamic>{
      'coordinateData': instance.coordinateData
          .map((e) => e.map((e) => e.toJson()).toList())
          .toList(),
    };
