import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:TransitEasy/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../constants.dart';

class EditNextBusesLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditNextBusesLayoutState();
}

class EditNextBusesLayoutState extends State<EditNextBusesLayout> {
  final SettingsService _settingsService = SettingsService();
  final FToast _fToast = FToast();
  final Widget _successToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Setting updated succesfully"),
      ],
    ),
  );

  final Widget _errorToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.redAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error),
        SizedBox(
          width: 12.0,
        ),
        Text("Failed to update setting, please try again"),
      ],
    ),
  );

  late int _currNextBuses;
  late int _savedNextBuses;
  bool _isFirstTime = true;

  Future<int> getRefreshIntervalSetting() {
    if (_isFirstTime) {
      _settingsService.getUserSettingsAsync().then<int>((value) async {
        _savedNextBuses = value.nextBuses;
        _currNextBuses = _savedNextBuses;
        return _currNextBuses;
      });
      _isFirstTime = false;
    }
    return Future.delayed(Duration.zero, () => _currNextBuses);
  }

  void handleOnValueChange(int value) {
    setState(() {
      _currNextBuses = value;
    });
  }

  void handleOnOkPressed() {
    if (_savedNextBuses != _currNextBuses) {
      _settingsService.setNextBusesSearchSetting(_currNextBuses).then((value) {
        return value
            ? {
                _fToast.showToast(
                    child: _successToast,
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2)),
                Navigator.pop(context)
              }
            : {
                _fToast.showToast(
                    child: _errorToast,
                    gravity: ToastGravity.BOTTOM,
                    toastDuration: Duration(seconds: 2)),
                Navigator.pop(context)
              };
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _fToast.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: getRefreshIntervalSetting(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return AlertDialog(
                title: Text(
                    "How many buses do you want to know about for each route?",
                    style: FontBuilder.buildCommonAppThemeFont(
                        18, Colors.black87)),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  NumberPicker(
                      minValue: 1,
                      maxValue: 6,
                      value: _currNextBuses,
                      step: 1,
                      itemWidth: 50,
                      axis: Axis.horizontal,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.black87)),
                      selectedTextStyle: TextStyle(color: Colors.purpleAccent),
                      onChanged: (value) => handleOnValueChange(value))
                ]),
                actions: [
                  TextButton(
                      child: Text("OK",
                          style: FontBuilder.buildCommonAppThemeFont(
                              18, Colors.black87)),
                      onPressed: handleOnOkPressed)
                ],
                elevation: 24.0,
                backgroundColor: Colors.cyanAccent);
          } else {
            return Container(
                child: SizedBox(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
                  ),
                  width: 60,
                  height: 60,
                ),
                alignment: Alignment.center,
                color: appPageColor);
          }
        });
  }
}
