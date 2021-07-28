import 'package:TransitEasy/models/usersettings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final int defaultStopsSearchRadiusMeters = 500;
  final int defaultBusAlertTrigger = 3;
  final int defaultBusLocationRefreshIntervalSeconds = 5;
  final int defaultNextBuses = 2;

  Future<UserSettings> getUserSettingsAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stopsSearchRadiusMeters = prefs.getInt('stopsSearchRadiusMeters') ??
        defaultStopsSearchRadiusMeters;
    if (stopsSearchRadiusMeters < 500)
      stopsSearchRadiusMeters = defaultStopsSearchRadiusMeters;
    var busAlertTrigger =
        prefs.getInt('busAlertTrigger') ?? defaultBusAlertTrigger;
    var busLocationRefreshIntervalSeconds =
        prefs.getInt('busLocationRefreshIntervalSeconds') ??
            defaultBusLocationRefreshIntervalSeconds;
    var nextBuses = prefs.getInt('nextBusesSearch') ?? defaultNextBuses;
    return new UserSettings(stopsSearchRadiusMeters, busAlertTrigger,
        busLocationRefreshIntervalSeconds, nextBuses);
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

  Future<bool> setNextBusesSearchSetting(int nextBuses) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt('nextBusesSearch', nextBuses);
  }
}
