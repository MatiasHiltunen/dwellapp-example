import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../providers/notification_provider.dart';
import '../../../providers/user_provider.dart';
import 'dwell_notifications_empty.dart';
import 'dwell_notifications_list.dart';

class DwellNotificationsListView extends StatelessWidget {
  const DwellNotificationsListView({
    Key? key,
  }) : super(key: key);

  bool _dataReady(AsyncSnapshot snapshot) =>
      snapshot.hasData &&
      snapshot.connectionState == ConnectionState.done &&
      snapshot.data['notifications'] != null &&
      (snapshot.data['notifications'] as List).isNotEmpty;

  bool _dataMissing(AsyncSnapshot snapshot) =>
      snapshot.connectionState == ConnectionState.done && !snapshot.hasData ||
      snapshot.connectionState == ConnectionState.done &&
          snapshot.hasData &&
          (snapshot.data['notifications'] as List).isEmpty;

  @override
  Widget build(BuildContext context) {
    final NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    return FutureBuilder(
      builder: (context, snapshot) {
        if (_dataReady(snapshot)) {
          notificationProvider.notificationsList = DwellNotificationsList(
              (snapshot.data as Map<String, dynamic>)['notifications']);
          return notificationProvider.notificationsList as Widget;
        }
        if (_dataMissing(snapshot)) {
          notificationProvider.notificationsList = null;
          return DwellNotificationsEmpty();
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (notificationProvider.notificationsList != null)
            return notificationProvider.notificationsList as Widget;
          return SpinKitWanderingCubes(color: Theme.of(context).primaryColor);
        }
        notificationProvider.notificationsList = null;
        return SizedBox.shrink();
      },
      future: Provider.of<User>(context, listen: false)
          .apiGet(endpoint: "notification"),
    );
  }
}
