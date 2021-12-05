import 'package:TransitEasy/blocs/blocs.dart';
import 'package:TransitEasy/blocs/busrouteslist_bloc.dart';
import 'package:TransitEasy/blocs/locationradiusconfig_bloc.dart';
import 'package:TransitEasy/blocs/nextbusschedule_bloc.dart';
import 'package:TransitEasy/blocs/permissions_bloc.dart';
import 'package:TransitEasy/blocs/pinnedstops_bloc.dart';
import 'package:TransitEasy/blocs/servicealerts_bloc.dart';
import 'package:TransitEasy/blocs/stopnumbersearch_bloc.dart';
import 'package:TransitEasy/blocs/stopslocationmap_bloc.dart';
import 'package:TransitEasy/blocs/userlocation_bloc.dart';
import 'package:TransitEasy/blocs/usersettings_bloc.dart';
import 'package:TransitEasy/clients/clients.dart';
import 'package:TransitEasy/provider/route_provider.dart';
import 'package:TransitEasy/repositories/repositories.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:TransitEasy/screens/stopslocation/stops_locations.dart';
import 'package:TransitEasy/services/dynamic_link_service.dart';
import 'package:TransitEasy/services/geolocation_service.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/observers/default_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  Bloc.observer = DefaultBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GeoLocationService _geoLocationService = GeoLocationService();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final UserLocationRepository _userLocationRepository =
        UserLocationRepository(_geoLocationService);
    final TransitEasyRepository _transitEasyRepository =
        TransitEasyRepository(TransitEasyApiClient());
    final UserSettingsRepository _userSettingsRepository =
        UserSettingsRepository(SettingsService());
    final UserLocationBloc _userLocationBloc =
        UserLocationBloc(_userLocationRepository);
    return FutureBuilder(
        future: initApp(),
        builder: (context, snapshot) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<PinnedStopsBloc>(
                    create: (BuildContext context) =>
                        PinnedStopsBloc(SettingsService())),
                BlocProvider<StopNumberSearchBloc>(
                    create: (BuildContext context) => StopNumberSearchBloc(
                        _userSettingsRepository, _transitEasyRepository)),
                BlocProvider<NextBusScheduleBloc>(
                    create: (BuildContext context) => NextBusScheduleBloc(
                        _userSettingsRepository, _transitEasyRepository)),
                BlocProvider<LocationRadiusConfigBloc>(
                    create: (BuildContext context) =>
                        LocationRadiusConfigBloc(SettingsService())),
                BlocProvider<PermissionsBloc>(
                    create: (BuildContext context) =>
                        PermissionsBloc(_geoLocationService)),
                BlocProvider<StopsInfoBloc>(
                    create: (BuildContext context) =>
                        StopsInfoBloc(_transitEasyRepository)),
                BlocProvider<StopsLocationsMapBloc>(
                    create: (BuildContext context) => StopsLocationsMapBloc(
                        _userLocationRepository,
                        _userSettingsRepository,
                        _transitEasyRepository)),
                BlocProvider<UserLocationBloc>(
                    create: (BuildContext context) => _userLocationBloc),
                BlocProvider(
                    create: (BuildContext context) =>
                        UserSettingsBloc(_userSettingsRepository)),
                BlocProvider(
                    create: (BuildContext context) =>
                        ServiceAlertsBloc(_transitEasyRepository)),
                BlocProvider(
                    create: (BuildContext context) =>
                        BusRoutesListBloc(_transitEasyRepository)),
              ],
              child: MaterialApp(
                title: 'TransitEasy',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primarySwatch: Colors.blue,
                    visualDensity: VisualDensity.adaptivePlatformDensity),
                initialRoute: '/',
                onGenerateRoute: RouteProvider.generateRoute,
                home: StopsLocationsScreen(),
              ));
        });
  }

  Future initApp() async {
    await Firebase.initializeApp();
    //await handleDynamicLinks();
  }

  /*Future handleDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? data) async {
      _handleDeepLink(data);
    }, onError: (OnLinkErrorException e) async {
      print("Dynamic link failed $e");
    });
  }

  void _handleDeepLink(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;
    print(deepLink?.queryParameters.toString());
    var x = deepLink?.queryParameters;
    if (deepLink != null) {
      Navigator.of(context).pushNamed(deepLink.path);
    }
  }*/

  @override
  void dispose() {
    super.dispose();
  }
}
