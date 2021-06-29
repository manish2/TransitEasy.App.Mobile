// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StopInfo _$StopInfoFromJson(Map<String, dynamic> json) {
  return StopInfo(
    json['stopNo'] as int,
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    json['stopName'] as String,
    json['bayNo'] as String,
    json['isWheelchairAccessible'] as bool,
    json['distance'] as int,
    (json['routes'] as List<dynamic>).map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$StopInfoToJson(StopInfo instance) => <String, dynamic>{
      'stopNo': instance.stopNo,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'stopName': instance.stopName,
      'bayNo': instance.bayNo,
      'isWheelchairAccessible': instance.isWheelchairAccessible,
      'distance': instance.distance,
      'routes': instance.routes,
    };
