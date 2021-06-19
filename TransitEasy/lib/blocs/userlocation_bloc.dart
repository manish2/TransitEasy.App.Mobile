import 'package:TransitEasy/blocs/events/userlocation/userlocation_event.dart';
import 'package:TransitEasy/blocs/events/userlocation/userlocation_requested.dart';
import 'package:TransitEasy/blocs/states/userlocation/userlocation_initial.dart';
import 'package:TransitEasy/blocs/states/userlocation/userlocation_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/userlocation/userlocation_load_success.dart';
import 'package:TransitEasy/blocs/states/userlocation/userlocation_state.dart';
import 'package:TransitEasy/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserLocationBloc extends Bloc<UserLocationEvent, UserLocationState> {
  final UserLocationRepository userLocationRepository;
  UserLocationBloc(this.userLocationRepository) : super(UserLocationInitial());

  @override
  Stream<UserLocationState> mapEventToState(UserLocationEvent event) async* {
    if (event is UserLocationRequested) yield UserLocationLoadInProgress();

    var userLocation = await userLocationRepository.getCurrentUserLocation();
    yield UserLocationLoadSuccess(userLocation);
  }
}
