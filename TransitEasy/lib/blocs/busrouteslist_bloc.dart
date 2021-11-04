import 'package:TransitEasy/blocs/events/busrouteslist/busroutes_event.dart';
import 'package:TransitEasy/blocs/events/busrouteslist/busroutes_requested.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_initial.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_load_failed.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_load_success.dart';
import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_state.dart';
import 'package:TransitEasy/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusRoutesListBloc extends Bloc<BusRoutesEvent, BusRoutesState> {
  final TransitEasyRepository _transitEasyRepository;

  BusRoutesListBloc(this._transitEasyRepository) : super(BusRoutesInitial());

  @override
  Stream<BusRoutesState> mapEventToState(BusRoutesEvent event) async* {
    yield BusRoutesLoadInProgress();
    try {
      if (event is BusRoutesRequested) {
        var data = await _transitEasyRepository.getRoutes();
        yield BusRoutesLoadSuccess(data.routesInfo ?? []);
      }
    } catch (exception) {
      yield BusRoutesLoadFailed();
    }
  }
}
