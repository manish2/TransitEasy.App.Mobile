import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_state.dart';
import 'package:TransitEasy/clients/models/stop_info.dart';
import 'package:TransitEasy/models/userlocation.dart';

class StopsLocationMapLoadSucess extends StopsLocationMapState {
  final List<StopInfo> busLocations;
  final UserLocation userLocation;
  final int userRadiusSetting;
  StopsLocationMapLoadSucess(
      this.busLocations, this.userLocation, this.userRadiusSetting);
}
