// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nextbus_stop_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NextBusStopInfo _$NextBusStopInfoFromJson(Map<String, dynamic> json) {
  return NextBusStopInfo(
    json['routeDescription'] as String,
    json['direction'] as String,
    (json['nextBusStopInfo'] as List<dynamic>)
        .map((e) => NextBusSchedule.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$NextBusStopInfoToJson(NextBusStopInfo instance) =>
    <String, dynamic>{
      'routeDescription': instance.routeDescription,
      'direction': instance.direction,
      'nextBusStopInfo':
          instance.nextBusStopInfo.map((e) => e.toJson()).toList(),
    };
