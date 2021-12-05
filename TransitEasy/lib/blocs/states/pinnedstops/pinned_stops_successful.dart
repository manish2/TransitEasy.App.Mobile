import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_state.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';

class PinnedStopsSuccesful extends PinnedStopsState {
  final List<StopInfoStreamModel> pinnedStops;

  PinnedStopsSuccesful(this.pinnedStops);

  @override
  List<Object> get props => [pinnedStops];
}
