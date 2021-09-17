import 'package:json_annotation/json_annotation.dart';

part 'service_alert.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceAlert {
  String alertId;
  String routeId;
  String routeLongName;
  String effect;
  String alertText;
  String alertHeader;
  String alertDescription;

  ServiceAlert(this.alertId, this.routeId, this.routeLongName, this.effect,
      this.alertText, this.alertHeader, this.alertDescription);
}
