import 'dart:async';
import 'package:TransitEasy/blocs/blocs.dart';
import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_event.dart';
import 'package:TransitEasy/blocs/events/stopslocationmap/stopslocationmap_requested.dart';
import 'package:TransitEasy/blocs/states/stopsinfo/stopsinfo_load_sucess.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_initial.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_load_success.dart';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_state.dart';
import 'package:TransitEasy/blocs/states/userlocation/userlocation_load_success.dart';
import 'package:TransitEasy/blocs/states/usersettings/usersettings_load_sucess.dart';
import 'package:TransitEasy/blocs/userlocation_bloc.dart';
import 'package:TransitEasy/blocs/usersettings_bloc.dart';
import 'package:TransitEasy/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopsLocationsMapBloc
    extends Bloc<StopsLocationMapEvent, StopsLocationMapState> {
  final StopsInfoBloc stopsInfoBloc;
  final UserLocationBloc userLocationBloc;
  final UserSettingsBloc userSettingsBloc;
  late Set<Marker> markers = {};
  final StreamController<Set<Marker>> markersStream =
      new StreamController<Set<Marker>>();
  final StreamController<Set<Circle>> circlesStream =
      new StreamController<Set<Circle>>();
  late Circle radiusCircle;
  late Set<Circle> circles = {};
  late LatLng currLatLng;
  late StreamSubscription stopsInfoSubscription;
  late StreamSubscription userLocationSubscription;
  late StreamSubscription userSettingsSubscription;
  late CameraPosition cameraPosition;
  late Function(StopsInfoLoadSuccess event) onStopLocationMarkerTap;

  void addCurrentPositionMarker(UserLocationLoadSuccess event) {
    var latlng =
        LatLng(event.userLocation.latitude, event.userLocation.longitude);
    cameraPosition = CameraPosition(target: latlng, zoom: 16.0);
    markers.add(Marker(
        markerId: MarkerId("curr_pos_marker"),
        position: latlng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        draggable: false));
    radiusCircle = Circle(
        visible: false,
        center: currLatLng,
        strokeWidth: 2,
        fillColor: Color.fromRGBO(221, 160, 221, .6),
        strokeColor: appPageColor,
        circleId: CircleId("selected_range"));
    markersStream.sink.add(markers);
  }

  void addStopsPositionMarkers(StopsInfoLoadSuccess event) {
    var stopsInfo = event.stopsInfo;
    var stopMarkers = stopsInfo.map((stop) => Marker(
        markerId: MarkerId(stop.stopNo.toString()),
        position: LatLng(stop.latitude, stop.longitude),
        draggable: false,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
            title: "${stop.stopNo}: ${stop.stopName}",
            snippet: "Click to see more details",
            onTap: () => onStopLocationMarkerTap(event))));
    markers.addAll(stopMarkers);
    markersStream.sink.add(markers);
  }

  void addSearchRadiusCircle(UserSettingsLoadSuccess state) {
    var searchRadius = state.userSettings.searchRadiusKm;
    radiusCircle = Circle(
        visible: false,
        center: currLatLng,
        strokeWidth: 2,
        fillColor: Color.fromRGBO(221, 160, 221, .6),
        strokeColor: appPageColor,
        circleId: CircleId("selected_range"));
  }

  StopsLocationsMapBloc(
      this.stopsInfoBloc, this.userLocationBloc, this.userSettingsBloc)
      : super(StopsLocationMapInitial()) {
    userLocationSubscription = userLocationBloc.stream.listen((event) {
      if (event is UserLocationLoadSuccess) {
        addCurrentPositionMarker(event);
      }
    });
    stopsInfoSubscription = stopsInfoBloc.stream.listen((event) {
      if (event is StopsInfoLoadSuccess) {
        addStopsPositionMarkers(event);
      }
    });
    userSettingsSubscription = userSettingsBloc.stream.listen((event) {
      if (event is UserSettingsLoadSuccess) {}
    });
    markersStream.stream.listen((event) {
      var latlng = event
          .where((element) => element.markerId.value == "curr_pos_marker")
          .first
          .position;
    });
  }

  @override
  Stream<StopsLocationMapState> mapEventToState(
      StopsLocationMapEvent event) async* {
    if (event is StopsLocationMapRequested) {
      this.onStopLocationMarkerTap = event.onStopLocationMarkerTap;
    }
    yield StopsLocationMapLoadSucess();
  }

  void dispose() {
    stopsInfoSubscription.cancel();
    userLocationSubscription.cancel();
    userSettingsSubscription.cancel();
    markersStream.close();
    circlesStream.close();
  }
}
