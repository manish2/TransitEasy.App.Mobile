import 'package:TransitEasy/services/settings_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VehicleLocationBloc {
  final SettingsService _settingsService;
  bool _isSubscribed = false;
  late WebSocketChannel webSocketChannel;

  VehicleLocationBloc(this._settingsService);

  void subscribeVehicleLocationData(String? routeNo, int? stopNo) async {
    if (!_isSubscribed) {
      var settings = await _settingsService.getUserSettingsAsync();
      var refreshIntervalSettings = settings.busLocationInterval;
      String baseUrl =
          "wss://transiteasy3.azurewebsites.net/api/VehiclesLocation/getvehicleslocation?refreshIntervalInSeconds=$refreshIntervalSettings";
      var fullUri = baseUrl = routeNo != null
          ? baseUrl + "&routeNo=$routeNo"
          : baseUrl + "&stopNo=$stopNo";
      webSocketChannel = WebSocketChannel.connect(Uri.parse(fullUri));
      _isSubscribed = true;
    }
  }
}
