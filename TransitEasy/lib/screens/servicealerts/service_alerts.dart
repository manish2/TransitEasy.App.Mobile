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
import 'package:TransitEasy/screens/servicealerts/service_alert_item.dart';
import 'package:TransitEasy/screens/servicealerts/service_alerts_list.dart';
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

  Widget buildServiceAlerts(ServiceAlertResult apiResult) {
    List<ServiceAlertItem> busItems = [];
    apiResult.busAlerts.forEach((routeName, alertInfo) {
      busItems.add(new ServiceAlertItem(
          false,
          Text(routeName),
          new ServiceAlertsList(alertInfo.alerts
              .map((e) => new ServiceAlertItem(
                  false, Text(e.alertHeader), new Container()))
              .toList())));
    });
    return ListView(
      children: [
        Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0)),
        ExpansionPanelList(
          children: [
            new ExpansionPanel(
                backgroundColor: Colors.cyanAccent,
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(
                    title: Text("Bus"),
                  );
                },
                body: new ServiceAlertsList(busItems))
          ],
        )
      ],
    );
  }

  Widget buildServiceAlertsList(ServiceAlertResult apiResult) {
    List<Widget> result = [];
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
