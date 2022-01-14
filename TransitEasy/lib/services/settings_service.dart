import 'package:TransitEasy/models/usersettings.dart';
import 'package:TransitEasy/screens/stopslocation/stop_info_stream_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final int defaultStopsSearchRadiusMeters = 500;
  final int defaultBusAlertTrigger = 5;
  final int defaultBusLocationRefreshIntervalSeconds = 5;
  final int defaultNextBuses = 2;

  final String _stopsSearchRadiusMetersSettingKey = 'stopsSearchRadiusMeters';
  final String _busAlertTriggerSettingKey = 'busAlertTrigger';
  final String _busLocationRefreshIntervalSecondsSettingKey =
      'busLocationRefreshIntervalSeconds';
  final String _nextBusesSearchSettingKey = 'nextBusesSearch';
  final String _pinnedStopsSettingKey = 'pinnedStops';

  Future<UserSettings> getUserSettingsAsync() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var stopsSearchRadiusMeters =
        prefs.getInt(_stopsSearchRadiusMetersSettingKey) ??
            defaultStopsSearchRadiusMeters;
    if (stopsSearchRadiusMeters < 500)
      stopsSearchRadiusMeters = defaultStopsSearchRadiusMeters;
    var busAlertTrigger =
        prefs.getInt(_busAlertTriggerSettingKey) ?? defaultBusAlertTrigger;
    var busLocationRefreshIntervalSeconds =
        prefs.getInt(_busLocationRefreshIntervalSecondsSettingKey) ??
            defaultBusLocationRefreshIntervalSeconds;
    var nextBuses =
        prefs.getInt(_nextBusesSearchSettingKey) ?? defaultNextBuses;
    return new UserSettings(stopsSearchRadiusMeters, busAlertTrigger,
        busLocationRefreshIntervalSeconds, nextBuses);
  }

  Future<bool> setStopsSearchRadiusMetersSetting(int searchRadiusMeters) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_stopsSearchRadiusMetersSettingKey, searchRadiusMeters);
  }

  Future<bool> setBusLocationRefreshIntervalSecondsSetting(
      int busLocationInterval) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(
        _busLocationRefreshIntervalSecondsSettingKey, busLocationInterval);
  }

  Future<bool> setbusAlertTriggerSetting(int busAlertTrigger) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_busAlertTriggerSettingKey, busAlertTrigger);
  }

  Future<bool> setNextBusesSearchSetting(int nextBuses) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_nextBusesSearchSettingKey, nextBuses);
  }

  Future<bool> pinStop(StopInfoStreamModel model) async {
    final prefs = await SharedPreferences.getInstance();
    var pinnedStopsList = await getPinnedStops();
    if (pinnedStopsList
        .where((element) => element.contains(model.stopNo.toString()))
        .isEmpty) {
      pinnedStopsList.add(model.toJsonString());

      return prefs.setStringList(_pinnedStopsSettingKey, pinnedStopsList);
    }
    return Future.delayed(Duration.zero, () => true);
  }

  Future<bool> addPinnedStop(String stopNo) async {
    final prefs = await SharedPreferences.getInstance();
    var pinnedStopsList = await getPinnedStops();
    pinnedStopsList.add(stopNo);
    return prefs.setStringList(_pinnedStopsSettingKey, pinnedStopsList);
  }

  Future<List<String>> getPinnedStops() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_pinnedStopsSettingKey) ?? [];
  }
}
