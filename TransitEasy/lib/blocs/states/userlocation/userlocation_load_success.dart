import 'package:TransitEasy/blocs/states/userlocation/userlocation_state.dart';
import 'package:TransitEasy/models/userlocation.dart';

class UserLocationLoadSuccess extends UserLocationState {
  final UserLocation userLocation;
  const UserLocationLoadSuccess(this.userLocation);

  @override
  List<Object> get props => [userLocation];
}
