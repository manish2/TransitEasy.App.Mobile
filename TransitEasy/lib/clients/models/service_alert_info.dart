import 'package:TransitEasy/clients/models/service_alert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_alert_info.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceAlertInfo {
  int count;
  List<ServiceAlert> alerts;

  ServiceAlertInfo(this.count, this.alerts);
}
