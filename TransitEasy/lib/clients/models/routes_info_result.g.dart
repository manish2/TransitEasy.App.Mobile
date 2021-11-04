// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'routes_info_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoutesInfoResult _$RoutesInfoResultFromJson(Map<String, dynamic> json) {
  return RoutesInfoResult(
    _$enumDecode(_$ApiResponseStatusEnumMap, json['responseStatus'],
        unknownValue: ApiResponseStatus.Success),
    (json['routesInfo'] as List<dynamic>?)
        ?.map((e) => RouteInfo.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$RoutesInfoResultToJson(RoutesInfoResult instance) =>
    <String, dynamic>{
      'responseStatus': _$ApiResponseStatusEnumMap[instance.responseStatus],
      'routesInfo': instance.routesInfo?.map((e) => e.toJson()).toList(),
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
  ApiResponseStatus.NoVehiclesAvailable: 2,
};
