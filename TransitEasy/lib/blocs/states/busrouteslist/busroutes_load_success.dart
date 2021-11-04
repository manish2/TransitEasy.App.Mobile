import 'package:TransitEasy/blocs/states/busrouteslist/busroutes_state.dart';
import 'package:TransitEasy/clients/models/route_info.dart';

class BusRoutesLoadSuccess extends BusRoutesState {
  final List<RouteInfo> routesInfo;
  BusRoutesLoadSuccess(this.routesInfo);
}
