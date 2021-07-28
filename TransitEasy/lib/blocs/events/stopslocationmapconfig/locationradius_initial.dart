import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_event.dart';

class LocationRadiusInitial extends LocationRadiusEvent {
  final int configuredRadius;
  LocationRadiusInitial(this.configuredRadius);
  @override
  List<Object?> get props => [];
}
