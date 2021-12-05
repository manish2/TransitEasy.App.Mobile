import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_event.dart';

class NextBusScheduleRequested extends NextBusScheduleEvent {
  final int stopNumber;
  final double? stopLat;
  final double? stopLong;
  const NextBusScheduleRequested(this.stopNumber, this.stopLat, this.stopLong);

  @override
  List<Object?> get props => [];
}
