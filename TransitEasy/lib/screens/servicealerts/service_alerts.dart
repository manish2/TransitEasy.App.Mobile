import 'package:TransitEasy/blocs/events/servicealerts/servicealerts_requested.dart';
import 'package:TransitEasy/blocs/servicealerts_bloc.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_load_in_progress.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_load_success.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_state.dart';
import 'package:TransitEasy/clients/models/service_alert_result.dart';
import 'package:TransitEasy/common/widgets/error/error_page.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/constants.dart';
import 'package:TransitEasy/screens/servicealerts/service_alert_card.dart';
import 'package:TransitEasy/screens/servicealerts/service_alerts_count.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceAlertsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavBar _navBar = new NavBar();
  final ServiceAlertsBloc _serviceAlertsBloc;

  ServiceAlertsScreen(this._serviceAlertsBloc);

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

  List<Widget> buildBusAlertsList(ServiceAlertResult apiResult) {
    List<Widget> busAlerts = [];
    apiResult.busAlerts.forEach((routeName, alertInfo) {
      busAlerts.add(ExpansionTile(
        trailing: ServiceAlertsCount(alertInfo.count),
        title: Text(routeName),
        children: alertInfo.alerts
            .map((ai) => ServiceAlertCard(ai.alertHeader, ai.alertDescription))
            .toList(),
      ));
    });
    return busAlerts;
  }

  List<Widget> buildSkytrainAlertsList(ServiceAlertResult apiResult) {
    List<Widget> skyTrainAlerts = [];
    apiResult.skytrainAlerts.forEach((lineName, alertInfo) {
      skyTrainAlerts.add(ExpansionTile(
        trailing: ServiceAlertsCount(alertInfo.count),
        title: Text(lineName),
        children: alertInfo.alerts
            .map((ai) => ServiceAlertCard(ai.alertHeader, ai.alertDescription))
            .toList(),
      ));
    });
    return skyTrainAlerts;
  }

  List<Widget> buildSeabusAlerts(ServiceAlertResult apiResult) {
    return apiResult.seaBusAlerts.alerts
        .map((ai) => ServiceAlertCard(ai.alertHeader, ai.alertDescription))
        .toList();
  }

  List<Widget> buildStationAccessAlerts(ServiceAlertResult apiResult) {
    List<Widget> stationAccessAlerts = [];
    apiResult.stationAccessAlerts.forEach((stationName, alertInfo) {
      stationAccessAlerts.add(ExpansionTile(
        trailing: ServiceAlertsCount(alertInfo.count),
        title: Text(stationName),
        children: alertInfo.alerts
            .map((ai) => ServiceAlertCard(ai.alertHeader, ai.alertDescription))
            .toList(),
      ));
    });
    return stationAccessAlerts;
  }

  Widget buildServiceAlerts(ServiceAlertResult apiResult) {
    return ListView(
      children: [
        Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0)),
        ExpansionTile(
            collapsedBackgroundColor: Colors.cyanAccent,
            backgroundColor: Colors.cyanAccent,
            title: Text("Bus"),
            children: buildBusAlertsList(apiResult)),
        SizedBox(
          height: 20,
        ),
        ExpansionTile(
          collapsedBackgroundColor: Colors.cyanAccent,
          backgroundColor: Colors.cyanAccent,
          title: Text("Skytrain"),
          children: buildSkytrainAlertsList(apiResult),
        ),
        SizedBox(
          height: 20,
        ),
        ExpansionTile(
          collapsedBackgroundColor: Colors.cyanAccent,
          backgroundColor: Colors.cyanAccent,
          title: Text("Seabus"),
          children: buildSeabusAlerts(apiResult),
        ),
        SizedBox(height: 20),
        ExpansionTile(
          collapsedBackgroundColor: Colors.cyanAccent,
          backgroundColor: Colors.cyanAccent,
          title: Text("Station Access"),
          children: buildStationAccessAlerts(apiResult),
        ),
      ],
    );
  }

  Widget buildServiceAlertsList(ServiceAlertResult apiResult) {
    List<ExpansionPanel> test = [];
    List<ExpansionPanel> busResult = [];

    apiResult.busAlerts.forEach((routeName, alertInfo) {
      busResult.add(new ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
                title: Text(routeName),
                trailing: Text(alertInfo.count.toString()));
          },
          body: ExpansionPanelList(
            children: alertInfo.alerts
                .map((e) => new ExpansionPanel(
                    headerBuilder: (context, y) {
                      return Text(e.alertHeader);
                    },
                    body: new Container()))
                .toList(),
          )));
    });
    test.add(new ExpansionPanel(
        backgroundColor: Colors.cyanAccent,
        headerBuilder: (BuildContext context, bool isExpanded) {
          return ListTile(
            title: Text("Bus"),
          );
        },
        body: new ExpansionPanelList(
          children: busResult,
        )));

    return ListView(children: [
      Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0)),
      ExpansionPanelList(
        children: test,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _serviceAlertsBloc.add(new ServiceAlertsRequested());
    return BlocBuilder<ServiceAlertsBloc, ServiceAlertsState>(
      bloc: _serviceAlertsBloc,
      builder: (context, state) {
        if (state is ServiceAlertsLoadSuccess) {
          return Scaffold(
              backgroundColor: appPageColor,
              key: _scaffoldKey,
              drawer: _navBar,
              body: Stack(
                children: [
                  buildServiceAlerts(state.serviceAlertResult),
                  FloatingMenu(
                      onTap: () => _scaffoldKey.currentState!.openDrawer())
                ],
              ));
        } else if (state is ServiceAlertsLoadInProgress) {
          return getLoadingScreen();
        } else {
          return ErrorPage();
        }
      },
    );
  }
}
