import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_state.dart';
import 'package:TransitEasy/clients/models/service_alert_result.dart';

class ServiceAlertsLoadSuccess extends ServiceAlertsState {
  final ServiceAlertResult serviceAlertResult; 

  ServiceAlertsLoadSuccess(this.serviceAlertResult); 
}