// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_alert_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAlertInfo _$ServiceAlertInfoFromJson(Map<String, dynamic> json) {
  return ServiceAlertInfo(
    json['count'] as int,
    (json['alerts'] as List<dynamic>)
        .map((e) => ServiceAlert.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ServiceAlertInfoToJson(ServiceAlertInfo instance) =>
    <String, dynamic>{
      'count': instance.count,
      'alerts': instance.alerts.map((e) => e.toJson()).toList(),
    };
