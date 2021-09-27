import 'package:flutter/widgets.dart';

class ServiceAlertItem {
  bool isExpanded;
  final Widget header;
  final Widget body;

  ServiceAlertItem(this.isExpanded, this.header, this.body);
}
