import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkSevice {
  static Future handleDynamicLinks() async {
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

  static void _handleDeepLink(PendingDynamicLinkData? data) {
    final Uri? deepLink = data?.link;
    if (deepLink != null) {}
  }
}
