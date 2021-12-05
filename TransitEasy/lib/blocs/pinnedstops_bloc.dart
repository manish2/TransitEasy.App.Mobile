import 'dart:convert';

import 'package:TransitEasy/blocs/events/pinnedstops/pin_stop_request.dart';
import 'package:TransitEasy/blocs/events/pinnedstops/pinned_stops_event.dart';
import 'package:TransitEasy/blocs/events/pinnedstops/pinned_stops_requested.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pin_stop_sucessful.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_initial.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_state.dart';
import 'package:TransitEasy/blocs/states/pinnedstops/pinned_stops_successful.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinnedStopsBloc extends Bloc<PinnedStopsEvent, PinnedStopsState> {
  final SettingsService _settingsService;

  PinnedStopsBloc(this._settingsService) : super(PinnedStopsInitial());

  @override
  Stream<PinnedStopsState> mapEventToState(PinnedStopsEvent event) async* {
    //this means that user wants to get all pinned stops
    if (event is PinnedStopsRequested) {
      yield PinnedStopsLoadInProgress();
      var pinnedStops = await _settingsService.getPinnedStops();
      var convertedPinnedStops = pinnedStops.map((e) {
        var parsedObj = json.decode(e) as Map<String, dynamic>;
        return StopInfoStreamModel.fromJson(parsedObj);
      }).toList();
      yield PinnedStopsSuccesful(convertedPinnedStops);
    }
    //this means that user wants to add a pinned stop
    else if (event is PinStopRequested) {
      await _settingsService.pinStop(event.stopInfoStreamModel);
      yield PinStopSucessful();
    }
  }
}
