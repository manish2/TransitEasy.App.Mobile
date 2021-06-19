import 'package:TransitEasy/common/models/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final int defaultStopsSearchRadiusMeters = 100;
  final int defaultBusAlertTrigger = 3;
  final int defaultBusLocationRefreshIntervalSeconds = 5;

  Future<UserSettings> getUserSettingsAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stopsSearchRadiusMeters = prefs.getInt('stopsSearchRadiusMeters') ??
        defaultStopsSearchRadiusMeters;
    var busAlertTrigger =
        prefs.getInt('busAlertTrigger') ?? defaultBusAlertTrigger;
    var busLocationRefreshIntervalSeconds =
        prefs.getInt('busLocationRefreshIntervalSeconds') ??
            defaultBusLocationRefreshIntervalSeconds;
    return new UserSettings(stopsSearchRadiusMeters, busAlertTrigger,
        busLocationRefreshIntervalSeconds);
  }

  Future<bool> setStopsSearchRadiusMetersSetting(int searchRadiusMeters) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt('stopsSearchRadiusMeters', searchRadiusMeters);
  }

  Future<bool> setBusLocationRefreshIntervalSecondsSetting(
      int busLocationInterval) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(
        'busLocationRefreshIntervalSeconds', busLocationInterval);
  }

  Future<bool> setbusAlertTriggerSetting(int busAlertTrigger) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt('busAlertTrigger', busAlertTrigger);
  }
}
