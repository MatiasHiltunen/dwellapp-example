import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/notification.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../screens/board/board_screen.dart';
import '../../../tools/custom_route.dart';
import '../../../tools/logging.dart';
import '../notification_screen.dart';
import 'dwell_notification.dart';

class DwellNotificationsList extends StatefulWidget {
  final List<dynamic>? notificationsList;

  const DwellNotificationsList(
    this.notificationsList, {
    Key? key,
  }) : super(key: key);

  @override
  _DwellNotificationsListState createState() => _DwellNotificationsListState();
}

class _DwellNotificationsListState extends State<DwellNotificationsList> {
  Future<void> _navigateToSingle(
      BuildContext context, DwellNotification d, String uid) async {
    final _notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    Log.warn(
        "notification ", d.body, d.id, d.isMessage, d.immediateParent, d.ref);

    if (d.isMessage) {
      Navigator.of(context)
          .popAndPushNamed(BoardScreen.routeName, arguments: d);
      // Navigator.pushNamedAndRemoveUntil(context, BoardScreen.routeName, (route) => route.isFirst, arguments: d);
    } else {
      Navigator.push(
        context,
        CustomPageRoute(
            builder: (_) => DwellSingleNotificationWidget(data: d),
            settings: null),
      );
    }

    /* void remove() {
      d.read.remove(uid);
      _notificationProvider.notificationsCount++;
    } */

    void add() async {
      d.read.add(uid);
      _notificationProvider.notificationsCount--;
      await Provider.of<User>(context, listen: false)
          .apiPatch(endpoint: "notification/${d.id}");
    }

    setState(() {
      if (!d.read.contains(uid)) add();
    });
  }

  Dismissible _buildNotifications(dynamic e, String uid, BuildContext context) {
    DwellNotification d = DwellNotification.fromJson(e)..uid = uid;

    void _delete(_) async {
      try {
        await Provider.of<User>(context, listen: false)
            .apiDelete(endpoint: "notification/${d.id}/recipients");
      } catch (e) {
        Log.error("Delete notification: ", e);
      }
      Provider.of<NotificationProvider>(context, listen: false)
          .notificationsList = null;
    }

    return Dismissible(
      background: Icon(
        Icons.delete_forever_outlined,
        color: Colors.white,
        size: 40,
      ),
      key: Key(d.id),
      onDismissed: _delete,
      child: GestureDetector(
        onTap: () =>
            _navigateToSingle(context, d, uid).catchError((e) => Log.error(e)),
        child: DwellNotificationWidget(data: d),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? uid = Provider.of<User>(context, listen: false).id;

    if (uid == null) throw Exception("uid can't be null");
    return ListView.builder(
      itemBuilder: (ctx, i) =>
          _buildNotifications(widget.notificationsList?[i], uid, ctx),
      itemCount: widget.notificationsList?.length,
    );
  }
}
