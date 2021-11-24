import 'package:TransitEasy/blocs/events/schedulednotifications/scheduled_notification_event.dart';

class CreateScheduledNotificationRequested extends ScheduledNotificationEvent {
  final DateTime expectedLeaveTime;
  final String routeNo;
  final String destination;
  final String stopNo;

  const CreateScheduledNotificationRequested(
      this.expectedLeaveTime, this.routeNo, this.destination, this.stopNo);

  @override
  List<Object?> get props => [];
}
