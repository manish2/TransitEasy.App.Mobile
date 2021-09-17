// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_alert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAlert _$ServiceAlertFromJson(Map<String, dynamic> json) {
  return ServiceAlert(
    json['alertId'] as String,
    json['routeId'] as String,
    json['routeLongName'] as String,
    json['effect'] as String,
    json['alertText'] as String,
    json['alertHeader'] as String,
    json['alertDescription'] as String,
  );
}

Map<String, dynamic> _$ServiceAlertToJson(ServiceAlert instance) =>
    <String, dynamic>{
      'alertId': instance.alertId,
      'routeId': instance.routeId,
      'routeLongName': instance.routeLongName,
      'effect': instance.effect,
      'alertText': instance.alertText,
      'alertHeader': instance.alertHeader,
      'alertDescription': instance.alertDescription,
    };
