// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_stops_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearbyStopsResult _$NearbyStopsResultFromJson(Map<String, dynamic> json) {
  return NearbyStopsResult(
    _$enumDecode(_$ApiResponseStatusEnumMap, json['responseStatus'],
        unknownValue: ApiResponseStatus.Success),
    (json['nearbyStopsInfo'] as List<dynamic>?)
        ?.map((e) => StopInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$NearbyStopsResultToJson(NearbyStopsResult instance) =>
    <String, dynamic>{
      'responseStatus': _$ApiResponseStatusEnumMap[instance.responseStatus],
      'nearbyStopsInfo':
          instance.nearbyStopsInfo?.map((e) => e.toJson()).toList(),
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

const _$ApiResponseStatusEnumMap = {
  ApiResponseStatus.Success: 0,
  ApiResponseStatus.NoStopsNearLocation: 1,
};
