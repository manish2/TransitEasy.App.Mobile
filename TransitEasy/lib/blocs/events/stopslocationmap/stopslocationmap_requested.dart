import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_event.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_load_sucess.dart';

class StopsLocationMapRequested extends StopsLocationMapEvent {
  final Function(StopsInfoLoadSuccess event) onStopLocationMarkerTap;
  const StopsLocationMapRequested(this.onStopLocationMarkerTap);

  @override
  List<Object?> get props => [];
}
