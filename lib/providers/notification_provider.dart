import '../screens/notifications/widgets/dwell_notifications_list.dart';
import 'package:flutter/material.dart';

class NotificationProvider extends ChangeNotifier {
  int notificationsCount = 0;
  DwellNotificationsList? notificationsList;
  DateTime lastCheckedCount = DateTime(2000);

  set count(int val) {
    notificationsCount = val;
  }

  void clear() {
    notificationsList = null;
    notificationsCount = 0;
  }
}
