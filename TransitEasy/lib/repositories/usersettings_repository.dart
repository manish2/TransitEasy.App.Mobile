import 'package:TransitEasy/models/usersettings.dart';
import 'package:TransitEasy/services/settings_service.dart';

class UserSettingsRepository {
  final SettingsService _settingsService;

  UserSettingsRepository(this._settingsService);

  Future<UserSettings> getUserSettingsAsync() async =>
      await _settingsService.getUserSettingsAsync();

  Future<bool> setStopsSearchRadiusMetersSetting(
          int searchRadiusMeters) async =>
      await _settingsService
          .setStopsSearchRadiusMetersSetting(searchRadiusMeters);

  Future<bool> setBusLocationRefreshIntervalSecondsSetting(
          int busLocationInterval) async =>
      await _settingsService
          .setBusLocationRefreshIntervalSecondsSetting(busLocationInterval);

  Future<bool> setbusAlertTriggerSetting(int busAlertTrigger) async =>
      await _settingsService.setbusAlertTriggerSetting(busAlertTrigger);
}
