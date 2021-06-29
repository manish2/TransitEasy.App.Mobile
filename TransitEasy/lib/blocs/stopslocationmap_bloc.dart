import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_event.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_initial.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_success.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_state.dart';
import 'package:TransitEasy/repositories/transiteasy_repository.dart';
import 'package:TransitEasy/repositories/userlocation_repository.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopsLocationsMapBloc
    extends Bloc<StopsLocationMapEvent, StopsLocationMapState> {
  final UserSettingsRepository _userSettingsRepository;
  final UserLocationRepository _userLocationRepository;
  final TransitEasyRepository _transitEasyRepository;

  StopsLocationsMapBloc(this._userLocationRepository,
      this._userSettingsRepository, this._transitEasyRepository)
      : super(StopsLocationMapInitial());

  @override
  Stream<StopsLocationMapState> mapEventToState(
      StopsLocationMapEvent event) async* {
    yield StopsLocationMapLoadInProgress();
    var userLocation = await _userLocationRepository.getCurrentUserLocation();
    var userSettings = await _userSettingsRepository.getUserSettingsAsync();
    var stopsInfos = await _transitEasyRepository.getNearbyStopsInfo(
        userLocation.latitude,
        userLocation.longitude,
        userSettings.searchRadiusKm);

    var locations = stopsInfos.nearbyStopsInfo ?? [];

    yield StopsLocationMapLoadSucess(
        locations, userLocation, userSettings.searchRadiusKm);
  }
}
