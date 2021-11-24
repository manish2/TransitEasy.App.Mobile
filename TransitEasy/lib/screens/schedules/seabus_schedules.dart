import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SeabusSchedulesScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SeabusSchedulesScreenState();
}

class _SeabusSchedulesScreenState extends State<SeabusSchedulesScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: 'https://www.translink.ca/schedules-and-maps/seabus',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          LinearProgressIndicator(
            value: progress.toDouble(),
            semanticsLabel: 'Linear progress indicator',
          );
        },
        gestureNavigationEnabled: true,
      ),
    );
  }
}
