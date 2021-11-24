// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_alert_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAlertResult _$ServiceAlertResultFromJson(Map<String, dynamic> json) {
  return ServiceAlertResult(
    (json['busAlerts'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(k, ServiceAlertInfo.fromJson(e as Map<String, dynamic>)),
    ),
    (json['skytrainAlerts'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(k, ServiceAlertInfo.fromJson(e as Map<String, dynamic>)),
    ),
    ServiceAlertInfo.fromJson(json['seaBusAlerts'] as Map<String, dynamic>),
    (json['stationAccessAlerts'] as Map<String, dynamic>).map(
      (k, e) =>
          MapEntry(k, ServiceAlertInfo.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$ServiceAlertResultToJson(ServiceAlertResult instance) =>
    <String, dynamic>{
      'busAlerts': instance.busAlerts.map((k, e) => MapEntry(k, e.toJson())),
      'skytrainAlerts':
          instance.skytrainAlerts.map((k, e) => MapEntry(k, e.toJson())),
      'seaBusAlerts': instance.seaBusAlerts.toJson(),
      'stationAccessAlerts':
          instance.stationAccessAlerts.map((k, e) => MapEntry(k, e.toJson())),
    };
