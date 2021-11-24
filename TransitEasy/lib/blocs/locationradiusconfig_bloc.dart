import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_decremented.dart';
import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_event.dart';
import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_incremented.dart';
import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_initial.dart';
import 'package:TransitEasy/blocs/events/stopslocationmapconfig/locationradius_saverequested.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocationRadiusConfigBloc extends Bloc<LocationRadiusEvent, int> {
  late int _configuredRadius;
  final SettingsService _settingsService;
  LocationRadiusConfigBloc(this._settingsService) : super(500);

  @override
  Stream<int> mapEventToState(LocationRadiusEvent event) async* {
    try {
      if (event is LocationRadiusSaveRequested) {
        await handleSaveRequested(event);
      }
      if (event is LocationRadiusInitial) {
        _configuredRadius = event.configuredRadius;
      } else if (event is LocationRadiusIncremented) {
        _configuredRadius += event.incrementFactor;
      } else if (event is LocationRadiusDecremented) {
        _configuredRadius -= event.decrementFactor;
      }
      yield _configuredRadius;
    } catch (_) {
      yield -1;
    }
  }

  Future<bool> handleSaveRequested(
          LocationRadiusSaveRequested saveRequest) async =>
      await _settingsService
          .setStopsSearchRadiusMetersSetting(saveRequest.radius);
}
