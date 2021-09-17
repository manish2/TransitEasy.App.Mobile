import 'package:TransitEasy/clients/models/service_alert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_alert_result.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceAlertResult {
  Map<String, ServiceAlert> busAlerts;

  ServiceAlertResult(this.busAlerts);
}
