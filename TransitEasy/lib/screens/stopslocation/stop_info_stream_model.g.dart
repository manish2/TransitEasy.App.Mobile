// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_info_stream_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopInfoStreamModel _$StopInfoStreamModelFromJson(Map<String, dynamic> json) {
  return StopInfoStreamModel(
    json['stopNo'] as int,
    json['stopName'] as String,
    (json['stopLat'] as num).toDouble(),
    (json['stopLong'] as num).toDouble(),
    json['isWheelchairAccessible'] as bool,
    json['distance'] as int,
    (json['routes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$StopInfoStreamModelToJson(
        StopInfoStreamModel instance) =>
    <String, dynamic>{
      'stopNo': instance.stopNo,
      'stopName': instance.stopName,
      'stopLat': instance.stopLat,
      'stopLong': instance.stopLong,
      'isWheelchairAccessible': instance.isWheelchairAccessible,
      'distance': instance.distance,
      'routes': instance.routes,
    };
