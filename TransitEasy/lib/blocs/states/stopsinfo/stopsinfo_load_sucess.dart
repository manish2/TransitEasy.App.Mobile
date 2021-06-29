import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_state.dart';
import 'package:TransitEasy/clients/models/stop_info.dart';

class StopsInfoLoadSuccess extends StopsInfoState {
  final List<StopInfo> stopsInfo;
  const StopsInfoLoadSuccess(this.stopsInfo);

  @override
  List<Object> get props => [stopsInfo];
}
