import 'package:TransitEasy/blocs/events/pinnedstops/pin_stop_request.dart';
import 'package:TransitEasy/services/settings_service.dart';

class PinnedStopsV2Bloc {
  final SettingsService _settingsService;

  PinnedStopsV2Bloc(this._settingsService);

  Future<bool> addPinnedStop(PinStopRequested event) async {
    return await _settingsService.pinStop(event.stopInfoStreamModel);
  }
}
