import 'package:TransitEasy/blocs/events/schedulednotifications/create_scheduled_notification_requested.dart';
import 'package:TransitEasy/blocs/events/schedulednotifications/scheduled_notification_event.dart';
import 'package:TransitEasy/blocs/states/schedulednotifications/scheduled_notification_add_failed.dart';
import 'package:TransitEasy/blocs/states/schedulednotifications/scheduled_notification_add_succeeded.dart';
import 'package:TransitEasy/blocs/states/schedulednotifications/scheduled_notification_completed.dart';
import 'package:TransitEasy/blocs/states/schedulednotifications/scheduled_notification_state.dart';
import 'package:TransitEasy/clients/models/request/create_scheduled_notification_request.dart';
import 'package:TransitEasy/clients/transiteasy_scheduler_api_client.dart';
import 'package:TransitEasy/repositories/usersettings_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ScheduledNotificationsBloc {
  final TransitEasySchedulerApiClient _transitEasySchedulerApiClient;
  final UserSettingsRepository _settingsRepository;

  ScheduledNotificationsBloc(
      this._transitEasySchedulerApiClient, this._settingsRepository);

  Future<ScheduledNotificationState> handleEvent(
      ScheduledNotificationEvent event) async {
    if (event is CreateScheduledNotificationRequested) {
      var userSettings = await _settingsRepository.getUserSettingsAsync();
      var fcmToken = await FirebaseMessaging.instance.getToken();
      var formattedTimestamp =
          _formatISOTimeToDatetimeOffset(event.expectedLeaveTime);
      var data = await _transitEasySchedulerApiClient.scheduleNotification(
          CreateScheduledNotificationRequest(
              formattedTimestamp,
              userSettings.busAlertTrigger,
              fcmToken ?? "",
              event.routeNo,
              event.destination,
              event.stopNo,
              userSettings.nextBuses));

      if (data != null) {
        return ScheduledNotificationAddSucceeded();
      } else {
        return ScheduledNotificationAddFailed();
      }
    } else {
      return ScheduledNotificationCompleted();
    }
  }

  String _formatISOTimeToDatetimeOffset(DateTime date) {
    var duration = date.timeZoneOffset;
    var timeZone = duration.abs().toString().split(':');
    var parsedTimeZone = '-0' + timeZone[0] + ':' + timeZone[1];
    return date.toIso8601String() + parsedTimeZone;
  }
}
