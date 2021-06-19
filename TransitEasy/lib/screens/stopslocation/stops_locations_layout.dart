import 'dart:async';
import 'package:TransitEasy/blocs/states/stopslocationmap/stopslocationmap_state.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopsLocationsLayout extends StatelessWidget {
  final StopsLocationsMapBloc stopsLocationsMapBloc;

  StopsLocationsLayout(this.stopsLocationsMapBloc);

  final Completer<GoogleMapController> _controller = Completer();

  StreamBuilder<Set<Marker>> _getMap(
          StopsLocationsMapBloc mapBloc, Set<Circle> circle) =>
      StreamBuilder<Set<Marker>>(
          stream: mapBloc.markersStream.stream,
          builder: (context, markerDataSnapshot) {
            return Stack(children: [
              GoogleMap(
                mapType: MapType.normal,
                zoomControlsEnabled: true,
                initialCameraPosition: mapBloc.cameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: markerDataSnapshot.data!,
                circles: circle,
              )
            ]);
          });

  Widget getLoadingScreen() {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopsLocationsMapBloc, StopsLocationMapState>(
        bloc: stopsLocationsMapBloc,
        builder: (context, state) {
          return StreamBuilder<Set<Circle>>(
              stream: stopsLocationsMapBloc.circlesStream.stream,
              builder: (context, circlesDataSnapshot) => circlesDataSnapshot
                              .data !=
                          null &&
                      circlesDataSnapshot.data!.isNotEmpty
                  ? _getMap(stopsLocationsMapBloc, circlesDataSnapshot.data!)
                  : getLoadingScreen());
        });
  }
}
