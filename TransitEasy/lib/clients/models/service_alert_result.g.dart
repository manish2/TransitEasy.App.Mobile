// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_alert_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAlertResult _$ServiceAlertResultFromJson(Map<String, dynamic> json) {
  return ServiceAlertResult(
    (json['busAlerts'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, ServiceAlert.fromJson(e as Map<String, dynamic>)),
    ),
  );
}

Map<String, dynamic> _$ServiceAlertResultToJson(ServiceAlertResult instance) =>
    <String, dynamic>{
      'busAlerts': instance.busAlerts.map((k, e) => MapEntry(k, e.toJson())),
    };
