import 'package:TransitEasy/common/services/settings_service.dart';
import 'package:TransitEasy/common/utils/font_builder.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../constants.dart';

class EditBusLocationLayout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EditBusLocationLayoutState();
}

class EditBusLocationLayoutState extends State<EditBusLocationLayout> {
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

  late int _currlocationRefreshIntervalValue;
  late int _savedlocationRefreshIntervalValue;
  bool _isFirstTime = true;

  Future<int> getRefreshIntervalSetting() {
    if (_isFirstTime) {
      _settingsService.getUserSettingsAsync().then<int>((value) async {
        _savedlocationRefreshIntervalValue = value.busLocationInterval;
        _currlocationRefreshIntervalValue = _savedlocationRefreshIntervalValue;
        return _currlocationRefreshIntervalValue;
      });
      _isFirstTime = false;
    }
    return Future.delayed(
        Duration.zero, () => _currlocationRefreshIntervalValue);
  }

  void handleOnValueChange(int value) {
    setState(() {
      _currlocationRefreshIntervalValue = value;
    });
  }

  void handleOnOkPressed() {
    if (_savedlocationRefreshIntervalValue !=
        _currlocationRefreshIntervalValue) {
      _settingsService
          .setBusLocationRefreshIntervalSecondsSetting(
              _currlocationRefreshIntervalValue)
          .then((value) {
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
                    "When should I refresh the real-time bus location (in seconds)?",
                    style:
                        FontBuilder.buildCommonAppThemeFont(18, Colors.white)),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  NumberPicker(
                      minValue: 1,
                      maxValue: 120,
                      value: _currlocationRefreshIntervalValue,
                      step: 1,
                      itemWidth: 50,
                      axis: Axis.horizontal,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white)),
                      onChanged: (value) => handleOnValueChange(value))
                ]),
                actions: [
                  TextButton(
                      child: Text("OK",
                          style: FontBuilder.buildCommonAppThemeFont(
                              18, Colors.white)),
                      onPressed: handleOnOkPressed)
                ],
                elevation: 24.0,
                backgroundColor: Color.fromRGBO(221, 160, 221, .6));
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
        });
  }
}
