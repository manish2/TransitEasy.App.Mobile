import 'package:TransitEasy/blocs/events/vehiclelocation/vehiclelocation_event.dart';

class VehicleLocationSubscribed extends VehicleLocationEvent {
  final int? stopNumber;
  final int? routeNumber;
  final int? refreshInSec;
  const VehicleLocationSubscribed(
      this.stopNumber, this.routeNumber, this.refreshInSec);
  @override
  List<Object?> get props => [stopNumber, routeNumber, refreshInSec];
}
