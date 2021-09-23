import 'package:TransitEasy/blocs/events/servicealerts/servicealerts_event.dart';
import 'package:TransitEasy/blocs/events/servicealerts/servicealerts_requested.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_initial.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_load_failed.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_load_success.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_state.dart';
import 'package:TransitEasy/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceAlertsBloc extends Bloc<ServiceAlertsEvent, ServiceAlertsState>{
  final TransitEasyRepository _transitEasyRepository; 

  ServiceAlertsBloc(this._transitEasyRepository) : super(ServiceAlertsInitial());

  @override
  Stream<ServiceAlertsState> mapEventToState(ServiceAlertsEvent event) async* {
    try {
      yield ServiceAlertsLoadInProgress(); 

      if(event is ServiceAlertsRequested) {
        var serviceAlerts = await _transitEasyRepository.getServiceAlerts(); 
        yield ServiceAlertsLoadSuccess(serviceAlerts); 
      }
    }
    catch(exception) {
      yield ServiceAlertsLoadFailed(); 
    }
  }
}