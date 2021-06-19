import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_state.dart';

class StopsInfoLoadFailure extends StopsInfoState {
  final String error;
  StopsInfoLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
