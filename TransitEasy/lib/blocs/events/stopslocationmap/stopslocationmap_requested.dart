import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_event.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_load_sucess.dart';
import 'package:TransitEasy/clients/models/stop_info.dart';

class StopsLocationMapRequested extends StopsLocationMapEvent {
  final bool isEditPage;
  final Function(StopsInfoLoadSuccess event, StopInfo info)
      onStopLocationMarkerTap;
  const StopsLocationMapRequested(
      this.onStopLocationMarkerTap, this.isEditPage);

  @override
  List<Object?> get props => [];
}
