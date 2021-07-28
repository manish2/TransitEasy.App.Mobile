import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_event.dart';

class LocationRadiusIncremented extends LocationRadiusEvent {
  final int incrementFactor;
  LocationRadiusIncremented(this.incrementFactor);
  @override
  List<Object?> get props => [];
}
