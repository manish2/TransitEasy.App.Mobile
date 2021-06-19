import 'dart:async';
import 'package:TransitEasy/common/services/api/stops_api_service.dart';
import 'package:TransitEasy/common/services/locations_services.dart';
import 'package:TransitEasy/common/services/settings_service.dart';
import 'package:TransitEasy/screens/stopslocation/stop_details.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants.dart';

class StopsLocationLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StopsLocationLayoutState();
}

class StopsLocationLayoutState extends State<StopsLocationLayout> {
  final LocationService _locationService = LocationService();
  final SettingsService _settingsService = SettingsService();
  final StopsApiService _stopsApiService = StopsApiService();

  late LatLng _latLng;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  Completer<GoogleMapController> _controller = Completer();

  Future<CameraPosition> getCurrentPosition() => _locationService
          .getCurrentUserPosition()
          .then<CameraPosition>((value) async {
        var settings = await _settingsService.getUserSettingsAsync();
        var stopLocations = await _stopsApiService.getAllClosestStopLocations(
            value.latitude, value.longitude, settings.searchRadiusKm);
        _latLng = LatLng(value.latitude, value.longitude);

        if (stopLocations != null && stopLocations.isNotEmpty) {
          var stopMarkers = stopLocations
              .map((e) => Marker(
                  markerId: MarkerId(e.stopNo.toString()),
                  position: LatLng(e.latitude, e.longitude),
                  draggable: false,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueOrange),
                  infoWindow: InfoWindow(
                      title: "${e.stopNo}: ${e.stopName}",
                      snippet: "Click to see more details",
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => StopDetails(e)))))
              .toSet();
          _markers = stopMarkers;
        }
        _markers.add(
          Marker(
              markerId: MarkerId("curr_pos_marker"),
              position: _latLng,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              draggable: false),
        );
        _circles.add(Circle(
            center: _latLng,
            strokeWidth: 2,
            fillColor: Color.fromRGBO(221, 160, 221, .6),
            strokeColor: appPageColor,
            radius: settings.searchRadiusKm.toDouble(),
            circleId: CircleId("selected_range")));
        return CameraPosition(target: _latLng, zoom: 16.0);
      });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CameraPosition>(
      future: getCurrentPosition(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Stack(children: <Widget>[
            GoogleMap(
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              initialCameraPosition: snapshot.data!,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _markers,
              circles: _circles,
            )
          ]);
        } else {
          return Container(
              child: SizedBox(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Color.fromRGBO(221, 160, 221, .6)),
                ),
                width: 60,
                height: 60,
              ),
              alignment: Alignment.center,
              color: appPageColor);
        }
      },
    );
  }
}
