import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_event.dart';

class LocationRadiusSaveRequested extends LocationRadiusEvent {
  final int radius;
  LocationRadiusSaveRequested(this.radius);
  @override
  List<Object?> get props => [];
}
