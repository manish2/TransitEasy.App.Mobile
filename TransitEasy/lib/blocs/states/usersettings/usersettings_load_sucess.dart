import 'package:TransitEasy/blocs/states/usersettings/usersettings_state.dart';
import 'package:TransitEasy/models/usersettings.dart';

class UserSettingsLoadSuccess extends UserSettingsState {
  final UserSettings userSettings;
  const UserSettingsLoadSuccess(this.userSettings);

  @override
  List<Object> get props => [userSettings];
}
