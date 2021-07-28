import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_event.dart';

class NextBusScheduleRequested extends NextBusScheduleEvent {
  final int stopNumber;

  const NextBusScheduleRequested(this.stopNumber);

  @override
  List<Object?> get props => [];
}
