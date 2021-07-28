import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_event.dart';

class LocationRadiusDecremented extends LocationRadiusEvent {
  final int decrementFactor;
  LocationRadiusDecremented(this.decrementFactor);
  @override
  List<Object?> get props => [];
}
