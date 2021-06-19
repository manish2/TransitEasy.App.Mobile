import 'package:TransitEasy/blocs/events/stopsinfo/stopsinfo_event.dart';

class StopsInfoRequested extends StopsInfoEvent {
  final double latitude;
  final double longitude;
  final int radius;
  const StopsInfoRequested(this.latitude, this.longitude, this.radius);

  @override
  List<Object?> get props => [latitude, longitude, radius];
}
