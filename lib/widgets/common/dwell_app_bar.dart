import 'package:Kuluma/config.dart';
import '../../tools/custom_route.dart';
import '../../providers/notification_provider.dart';
import '../../providers/user_provider.dart';
import '../../screens/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DwellAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DwellAppBar(
      {Key? key, required this.title, this.disableActions = false})
      : super(key: key);

  final Widget title;
  final bool disableActions;

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: DwellColors.textWhite,
      ),
      title: title,
      centerTitle: true,
      actions: [
        if (!disableActions) DwellNotificationCountLogo(),
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}

class DwellNotificationCountLogo extends StatefulWidget {
  @override
  _DwellNotificationCountLogoState createState() =>
      _DwellNotificationCountLogoState();
}

class _DwellNotificationCountLogoState
    extends State<DwellNotificationCountLogo> {
  bool _ready(AsyncSnapshot snapshot) =>
      snapshot.connectionState == ConnectionState.done &&
      snapshot.hasData &&
      !snapshot.hasError &&
      snapshot.data['unread_count'] != null;

  bool _force = false;

  @override
  Widget build(BuildContext context) {
    final NotificationProvider _notificationProvider =
        Provider.of<NotificationProvider>(context, listen: false);

    return GestureDetector(
      onTap: () => Navigator.push(
              context, CustomPageRoute(builder: (_) => NotificationsScreen()))
          .then((val) => setState(() {
                // Log.info(val);
                _force = true;
              })),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                'assets/images/bell.png',
                scale: 1.7,
              ),
            ),
            _notificationProvider.lastCheckedCount.isBefore(
                        DateTime.now().subtract(Duration(seconds: 10))) ||
                    _force
                ? FutureBuilder(
                    builder: (context, snapshot) {
                      _force = false;
                      if (_ready(snapshot)) {
                        _notificationProvider.lastCheckedCount = DateTime.now();
                        _notificationProvider.count = (snapshot.data
                            as Map<String, dynamic>)['unread_count'] as int;
                      }
                      return DwellAppBarNotificationCount(
                          count: _notificationProvider.notificationsCount);
                    },
                    future: Provider.of<User>(context, listen: false)
                        .apiGet(endpoint: 'notification/unread/count'),
                  )
                : DwellAppBarNotificationCount(
                    count: _notificationProvider.notificationsCount),
          ],
        ),
      ),
    );
  }
}

class DwellAppBarNotificationCount extends StatelessWidget {
  const DwellAppBarNotificationCount({
    Key? key,
    required int count,
  })   : _count = count,
        super(key: key);

  final int _count;

  @override
  Widget build(BuildContext context) {
    if (_count > 0)
      return Text(_count.toString(),
          style: const TextStyle(fontSize: 18, color: Colors.white));
    if (_count > 99)
      return Text("+99",
          style: const TextStyle(fontSize: 18, color: Colors.white));
    return SizedBox.shrink();
  }
}
