import 'package:TransitEasy/repositories/models/pinned_stop.dart';
import 'package:TransitEasy/services/settings_service.dart';

class PinnedStopsRepository {
  final SettingsService _settingsService;

  PinnedStopsRepository(this._settingsService);

  Future<List<PinnedStop>> getPinnedStops() async {
    var data = await _settingsService.getPinnedStopsCsv();
    return data
        .map((e) => PinnedStop.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
