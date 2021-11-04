// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteInfo _$RouteInfoFromJson(Map<String, dynamic> json) {
  return RouteInfo(
    json['routeId'] as int,
    json['routeShortName'] as String,
    json['routeLongName'] as String,
  );
}

Map<String, dynamic> _$RouteInfoToJson(RouteInfo instance) => <String, dynamic>{
      'routeId': instance.routeId,
      'routeShortName': instance.routeShortName,
      'routeLongName': instance.routeLongName,
    };
