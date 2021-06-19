import 'package:TransitEasy/blocs/events/usersettings/usersettings_event.dart';
import 'package:TransitEasy/blocs/events/usersettings/usersettings_requested.dart';
import 'package:TransitEasy/blocs/states/usersettings/usersettings_initial.dart';
import 'package:TransitEasy/blocs/states/usersettings/usersettings_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/usersettings/usersettings_load_sucess.dart';
import 'package:TransitEasy/blocs/states/usersettings/usersettings_state.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserSettingsBloc extends Bloc<UserSettingsEvent, UserSettingsState> {
  final UserSettingsRepository _userSettingsRepository;
  UserSettingsBloc(this._userSettingsRepository) : super(UserSettingsInitial());

  @override
  Stream<UserSettingsState> mapEventToState(event) async* {
    if (event is UserSettingsRequested) yield UserSettingsLoadInProgress();

    var data = await _userSettingsRepository.getUserSettingsAsync();
    yield UserSettingsLoadSuccess(data);
  }
}
