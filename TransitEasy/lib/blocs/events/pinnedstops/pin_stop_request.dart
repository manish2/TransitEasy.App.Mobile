import 'package:TransitEasy/blocs/events/pinnedstops/pinned_stops_event.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';

class PinStopRequested extends PinnedStopsEvent {
  final StopInfoStreamModel stopInfoStreamModel;
  PinStopRequested(this.stopInfoStreamModel);
}
