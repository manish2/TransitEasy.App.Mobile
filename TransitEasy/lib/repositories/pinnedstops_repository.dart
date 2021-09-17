import 'package:TransitEasy/services/settings_service.dart';

class PinnedStopsRepository {
  final SettingsService _settingsService;

  PinnedStopsRepository(this._settingsService);

  Future<List<String>> getPinnedStops() async {
    return await _settingsService.getPinnedStopsCsv();
  }
}
