import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_event.dart';
import 'package:TransitEasy/blocs/events/nextbuschedule/nextbusschedule_requested.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_initial.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_failed.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_load_success.dart';
import 'package:TransitEasy/blocs/states/nextbusschedule/nextbusschedule_state.dart';
import 'package:TransitEasy/repositories/transiteasy_repository.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StopNumberSearchBloc
    extends Bloc<NextBusScheduleEvent, NextBusScheduleState> {
  final UserSettingsRepository _userSettingsRepository;
  final TransitEasyRepository _transitEasyRepository;

  StopNumberSearchBloc(
      this._userSettingsRepository, this._transitEasyRepository)
      : super(NextBusScheduleInitial());

  @override
  Stream<NextBusScheduleState> mapEventToState(
      NextBusScheduleEvent event) async* {
    yield NextBusScheduleLoadInProgress();

    try {
      var userSettings = await _userSettingsRepository.getUserSettingsAsync();
      var numBuses = userSettings.nextBuses;
      if (event is NextBusScheduleRequested) {
        var stopNumber = event.stopNumber;
        var nextBusScheduleInfo = await _transitEasyRepository
            .getNextBusSchedules(stopNumber, numBuses);
        yield NextBusScheduleLoadSuccess(
            nextBusScheduleInfo.nextBusStopInfo, stopNumber);
      }
    } catch (_) {
      yield NextBusScheduleLoadFailed();
    }
  }
}
