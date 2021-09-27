import 'package:TransitEasy/clients/models/service_alert_result.dart';
import 'package:TransitEasy/screens/servicealerts/service_alert_item.dart';
import 'package:flutter/material.dart';

class ServiceAlertsList extends StatefulWidget {
  final List<ServiceAlertItem> _items;

  ServiceAlertsList(this._items);

  @override
  State<StatefulWidget> createState() => _ServiceAlertsListState(_items);
}

class _ServiceAlertsListState extends State<ServiceAlertsList> {
  final List<ServiceAlertItem> _items;

  _ServiceAlertsListState(this._items);

/*   List<ExpansionPanel> buildServiceAlertsList(ServiceAlertResult apiResult) {
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
    return test;
    //return ListView(children: [
    //  Padding(padding: EdgeInsets.fromLTRB(0, 80, 0, 0)),
    //  ExpansionPanelList(
    //   children: test,
    //  )
    // ]);
  } */

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _items[index].isExpanded = !_items[index].isExpanded;
        });
      },
      children: _items
          .map((e) => new ExpansionPanel(
              headerBuilder: (buildContext, isExpanded) {
                return e.header;
              },
              body: e.body))
          .toList(),
    );
/*     return ListView(
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _items[index].isExpanded = !_items[index].isExpanded;
            });
          },
          children: buildServiceAlertsList(_apiResult),
        )
      ],
    ); */
  }
}
