import 'package:TransitEasy/blocs/events/stopsinfo/stopsinfo_event.dart';
import 'package:TransitEasy/blocs/events/stopsinfo/stopsinfo_requested.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_initial.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_load_sucess.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_loadfailure.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_state.dart';
import 'package:TransitEasy/common/models/api_response_status.dart';
import 'package:TransitEasy/common/models/nearby_stops_result.dart';
import 'package:TransitEasy/repositories/transiteasy_repository.dart';
import 'package:bloc/bloc.dart';

class StopsInfoBloc extends Bloc<StopsInfoEvent, StopsInfoState> {
  final TransitEasyRepository transitEasyRepository;

  StopsInfoBloc(this.transitEasyRepository) : super(StopsInfoInitial());

  @override
  Stream<StopsInfoState> mapEventToState(StopsInfoEvent event) async* {
    if (event is StopsInfoRequested) {
      yield StopsInfoLoadInProgress();
      try {
        final NearbyStopsResult nearbyStopsResult = await transitEasyRepository
            .getNearbyStopsInfo(event.latitude, event.longitude, event.radius);
        if (nearbyStopsResult.responseStatus ==
            ApiResponseStatus.NoStopsNearLocation)
          yield StopsInfoLoadFailure("No stops near location");
        else
          yield StopsInfoLoadSuccess(nearbyStopsResult.nearbyStopsInfo!);
      } catch (_) {
        yield StopsInfoLoadFailure(
            "Sorry! Something went wrong please try again");
      }
    }
  }
}
