import 'dart:async';
import 'dart:convert';

import 'package:TransitEasy/clients/models/api_response_status.dart';
import 'package:TransitEasy/clients/models/vehicles_location_result.dart';
import 'package:TransitEasy/common/widgets/error/error_page.dart';
import 'package:TransitEasy/constants.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VehicleLocationLayout extends StatefulWidget {
  //final VehicleLocationBloc _vehicleLocationBloc;
  final int? stopNo;
  final String? routeNo;

  VehicleLocationLayout(this.stopNo, this.routeNo);

  @override
  State<StatefulWidget> createState() =>
      _VehicleLocationLayout(stopNo, routeNo);
}

class _VehicleLocationLayout extends State<VehicleLocationLayout> {
  //final VehicleLocationBloc _vehicleLocationBloc;
  final int? stopNo;
  final String? routeNo;
  late WebSocketChannel _webSocketChannel;
  bool _isSubscribed = false;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = new Set<Marker>();
  int _focusedBusIndex = 0;
  bool _isDataLoading = true;
  late VehiclesLocationResult _liveResult;
  static const CAMERA_ZOOM = 16.0;
  static const CAMERA_TILT = 15.0;
  late StreamSubscription _subscriptionListener;
  bool _isLocationUpdate = false;
  bool _dataLoadFailed = false;
  Set<Polyline> _polylines = new Set<Polyline>();
  _VehicleLocationLayout(this.stopNo, this.routeNo);

  Widget getLoadingScreen() {
    return Container(
        child: SizedBox(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
          ),
          width: 60,
          height: 60,
        ),
        alignment: Alignment.center,
        color: appPageColor);
  }

  @override
  void initState() {
    super.initState();
    try {
      if (!_isSubscribed) {
        _webSocketChannel = WebSocketChannel.connect(Uri.parse(
            "wss://transiteasy3.azurewebsites.net/api/VehiclesLocation/getvehicleslocation?refreshIntervalInSeconds=3&routeNo=$routeNo"));
        _subscriptionListener = _webSocketChannel.stream.listen((event) async {
          developer.log("EVENT CAPTURED: $event");
          var data = json.decode(event.toString()) as Map<String, dynamic>;
          var result = VehiclesLocationResult.fromJson(data);
          Set<Polyline> polyLines = new Set<Polyline>();
          var polyLineIdCount = 0;
          if (result.responseStatus == ApiResponseStatus.NoVehiclesAvailable) {
            setState(() {
              _dataLoadFailed = true;
            });
          } else {
            for (var coordinateData in result.vehicleLocations[_focusedBusIndex]
                .routeMapData.coordinateData) {
              var coordinates = coordinateData
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList();
              polyLines.add(Polyline(
                  polylineId: PolylineId(polyLineIdCount.toString()),
                  visible: true,
                  color: Colors.green,
                  points: coordinates));
              polyLineIdCount++;
            }
            setState(() {
              _dataLoadFailed = false;
              if (_isDataLoading) _isDataLoading = false;

              _liveResult = result;

              _markers = result.vehicleLocations
                  .map((location) => Marker(
                      markerId: MarkerId(location.vehicleNo),
                      position: LatLng(location.latitude, location.longitude)))
                  .toSet();

              _polylines = polyLines;
            });
          }
          if (_isLocationUpdate) {
            //when location is updated we need to move the camera with the updated marker for focused bus
            await _moveCameraToBusLocation();
          }
          if (!_isLocationUpdate) {
            //all subsequent events will be updates
            _isLocationUpdate = true;
          }
        });
        _isSubscribed = true;
      }
    } catch (e) {
      setState(() {
        _dataLoadFailed = true;
      });
    }
  }

  Future<void> moveCameraToNextBusLocation() async {
    developer.log("MOVING CAMERA TO NEXT LOCATION");
    if (_focusedBusIndex == _liveResult.vehicleLocations.length - 1) {
      _focusedBusIndex = 0;
    } else {
      _focusedBusIndex++;
    }
    await _moveCameraToBusLocation();
  }

  Future<void> moveCameraToPrevBusLocation() async {
    developer.log("MOVING CAMERA TO PREVIOUS LOCATION");
    if (_focusedBusIndex == 0) {
      _focusedBusIndex = _liveResult.vehicleLocations.length - 1;
    } else {
      _focusedBusIndex--;
    }
    await _moveCameraToBusLocation();
  }

  Future<void> _moveCameraToBusLocation() async {
    var currentFocusedBus = _liveResult.vehicleLocations[_focusedBusIndex];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentFocusedBus.latitude, currentFocusedBus.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: _getBearingFromDirection(currentFocusedBus.direction))));
  }

  @override
  Widget build(BuildContext context) {
    if (_dataLoadFailed) {
      return ErrorPage("An error occurred please try again");
    } else
      return _isDataLoading
          ? getLoadingScreen()
          : Stack(children: [
              _loadVehicleLocationMap(),
              Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  heroTag: "beforeBtn",
                  onPressed: moveCameraToPrevBusLocation,
                  child: Icon(Icons.navigate_before),
                ),
              ),
              Container(
                color: Colors.cyanAccent,
                child: Text(_liveResult
                        .vehicleLocations[_focusedBusIndex].pattern +
                    " " +
                    _liveResult.vehicleLocations[_focusedBusIndex].direction),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: "afterBtn",
                  onPressed: moveCameraToNextBusLocation,
                  child: Icon(Icons.navigate_next),
                ),
              )
            ]);
  }

  Widget _loadVehicleLocationMap() {
    if (_liveResult.responseStatus != ApiResponseStatus.Success) {
      return ErrorPage(getErrorMsg(_liveResult.responseStatus));
    }
    var currentFocusedBus = _liveResult.vehicleLocations[_focusedBusIndex];
    return GoogleMap(
        polylines: _polylines,
        markers: _markers,
        zoomGesturesEnabled: true,
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
            target:
                LatLng(currentFocusedBus.latitude, currentFocusedBus.longitude),
            zoom: CAMERA_ZOOM,
            tilt: CAMERA_TILT,
            bearing: _getBearingFromDirection(currentFocusedBus.direction)),
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        });
  }

  String getErrorMsg(ApiResponseStatus errorStatus) {
    if (errorStatus == ApiResponseStatus.NoVehiclesAvailable)
      return "Sorry! Could not find any vehicles servicing this route or stop";
    else
      return "OOPS! We encountered an error, please try again";
  }

  double _getBearingFromDirection(String direction) {
    switch (direction) {
      case "EAST":
        return 90;
      case "SOUTH":
        return 180;
      case "WEST":
        return 270;
      default:
        return 0;
    }
  }

  @override
  void deactivate() {
    super.deactivate();
    _subscriptionListener.cancel();
    _webSocketChannel.sink.close();
    developer.log("DEACTIVATE CALLED",
        name: 'transiteasy.screens.vehiclelocation.vehicle_locations_layout');
  }
}
