import 'package:Kuluma/generated/l10n.dart';

import '../../config.dart';
import '../../widgets/common/dwell_title.dart';
import 'package:flutter/material.dart';

import 'widgets/dwell_notifications_listview.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications_screen';

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: DwellTitle(title: S.of(context).notifications),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: Container(
          width: width,
          height: height,
          color: DwellColors.background,
          child: DwellNotificationsListView(),
        ),
      ),
    );
  }
}
