import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_state.dart';
import 'package:TransitEasy/clients/models/nextbus_stop_info.dart';

class NextBusScheduleLoadSuccess extends NextBusScheduleState {
  final List<NextBusStopInfo>? nextBusStopInfo;
  final int stopNo;
  NextBusScheduleLoadSuccess(this.nextBusStopInfo, this.stopNo);
  @override
  List<Object> get props => [nextBusStopInfo ?? []];
}
