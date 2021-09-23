import 'package:TransitEasy/blocs/servicealerts_bloc.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_load_success.dart';
import 'package:TransitEasy/blocs/states/servicealerts/servicealerts_state.dart';
import 'package:TransitEasy/clients/models/service_alert_result.dart';
import 'package:TransitEasy/common/widgets/floating_menu.dart';
import 'package:TransitEasy/common/widgets/navigation/nav_bar.dart';
import 'package:TransitEasy/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ServiceAlertsScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavBar _navBar = new NavBar();

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

  Widget buildServiceAlertsList(ServiceAlertResult apiResult) {
    List<Widget> result = []; 
    List<Widget> busResult = []; 
    apiResult.busAlerts.forEach((routeName, alertInfo) 
      {
        busResult.add(new ListTile(
           title: Text(routeName),
        ));
      }
    );  
    result.add(Container(decoration: BoxDecoration(
                  color: Colors.cyanAccent,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: ExpansionTile(
                     title: Container(
                      child: Text("Bus"),
                    ),
                    children: busResult
                  ),
              )
              );

    return ListView(children: result); 
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceAlertsBloc, ServiceAlertsState>(
      builder: (context, state) {
        if (state is ServiceAlertsLoadSuccess) {
          return Scaffold(
            key: _scaffoldKey,
            drawer: _navBar,
            body: Stack(
                  children: [
                    buildServiceAlertsList(state.serviceAlertResult),
                    FloatingMenu(
                        onTap: () => _scaffoldKey.currentState!.openDrawer())
                  ],)
          );
        }
        else {
          return getLoadingScreen();
        }
      },
    ); 
  }
}