import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_state.dart';
import 'package:TransitEasy/clients/models/nextbus_stop_info.dart';

class NextBusScheduleLoadSuccess extends NextBusScheduleState {
  final List<NextBusStopInfo>? nextBusStopInfo;
  NextBusScheduleLoadSuccess(this.nextBusStopInfo);
  @override
  List<Object> get props => [nextBusStopInfo ?? []];
}
