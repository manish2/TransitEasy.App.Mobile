import 'package:TransitEasy/clients/models/service_alert_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_alert_result.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceAlertResult {
  Map<String, ServiceAlertInfo> busAlerts;
  Map<String, ServiceAlertInfo> skytrainAlerts;
  ServiceAlertInfo seaBusAlerts;
  Map<String, ServiceAlertInfo> stationAccessAlerts;

  ServiceAlertResult(this.busAlerts, this.skytrainAlerts, this.seaBusAlerts,
      this.stationAccessAlerts);

  factory ServiceAlertResult.fromJson(Map<String, dynamic> json) =>
      _$ServiceAlertResultFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceAlertResultToJson(this);
}
