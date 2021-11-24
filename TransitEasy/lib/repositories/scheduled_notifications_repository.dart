import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduledNotificationsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> addScheduledNotification() {
    var scheduledNotificationsCollection =
        _firestore.collection('scheduled_notifications');
    return scheduledNotificationsCollection
        .add({'full_name': 'JOHN DOE', 'company': 'Stokes and Sons', 'age': 42})
        .then<String?>((value) => value.id)
        .catchError((error) => null);
  }
}
