// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nextbus_schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NextBusSchedule _$NextBusScheduleFromJson(Map<String, dynamic> json) {
  return NextBusSchedule(
    json['isTripCancelled'] as bool,
    json['isStopCancelled'] as bool,
    json['countdownInMin'] as int,
    _$enumDecode(_$NextBusScheduleStatusEnumMap, json['scheduleStatus']),
    json['destination'] as String,
  );
}

Map<String, dynamic> _$NextBusScheduleToJson(NextBusSchedule instance) =>
    <String, dynamic>{
      'isTripCancelled': instance.isTripCancelled,
      'isStopCancelled': instance.isStopCancelled,
      'countdownInMin': instance.countdownInMin,
      'scheduleStatus': _$NextBusScheduleStatusEnumMap[instance.scheduleStatus],
      'destination': instance.destination,
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$NextBusScheduleStatusEnumMap = {
  NextBusScheduleStatus.ONTIME: 0,
  NextBusScheduleStatus.DELAYED: 1,
  NextBusScheduleStatus.AHEAD: 2,
};
