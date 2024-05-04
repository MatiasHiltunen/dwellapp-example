import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/action_log/action_log_screen.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../screens/about/about_screen.dart';
import '../screens/board/board_screen.dart';

import '../screens/user/user_screen.dart';
import 'package:flutter/material.dart';

import '../screens/consumption/consumption_screen.dart';

class DwellDrawerItem {
  final String name;
  final String route;
  final bool pushReplacement;

  late bool selected;

  void navigate(BuildContext context) {
    if (selected)
      Scaffold.of(context).openEndDrawer();
    else if (route == 'logout') {
      Provider.of<User>(context, listen: false).logout();
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else if (pushReplacement)
      Navigator.of(context).pushReplacementNamed(route);
    else
      Navigator.of(context).pushNamed(route);
  }

  DwellDrawerItem(this.name, this.route, {this.pushReplacement = true});
}

class DwellDrawer extends StatefulWidget {
  @override
  _DwellDrawerState createState() => _DwellDrawerState();
}

class _DwellDrawerState extends State<DwellDrawer> {
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final List<DwellDrawerItem> drawerItems = [
      DwellDrawerItem(s.drawerHome, '/'),
      DwellDrawerItem(s.drawerConsumption, ConsumptionScreen.routeName),
      DwellDrawerItem(s.drawerBoard, BoardScreen.routeName),
      /* DwellDrawerItem(s.drawerNotifications, NotificationsScreen.routeName,
          pushReplacement: false), */
      DwellDrawerItem(s.drawerActionLog, ActionLogScreen.routeName),
      DwellDrawerItem(s.drawerUserInfo, UserScreen.routeName),
      DwellDrawerItem(s.drawerCommonInfo, AboutScreen.routeName),
      /* DwellDrawerItem(s.drawerSettings, SettingsScreen.routeName), */
      DwellDrawerItem(s.drawerLogout, 'logout'),
    ];
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final double height = MediaQuery.of(context).size.height;

    drawerItems
        .forEach((element) => element.selected = element.route == currentRoute);

    return ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: Drawer(
        child: Container(
          color: DwellColors.background,
          child: Column(
            children: [
              DwellDrawerTop(),
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: constraints.maxWidth,
                  height: height - 100,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return DwellDrawerItemWidget(
                          drawerItem: drawerItems[index]);
                    },
                    itemCount: drawerItems.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DwellDrawerItemWidget extends StatelessWidget {
  const DwellDrawerItemWidget({
    Key? key,
    required this.drawerItem,
  }) : super(key: key);

  final DwellDrawerItem drawerItem;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => drawerItem.navigate(context),
      child: Container(
        padding: EdgeInsets.only(left: 50, top: 4),
        alignment: Alignment.centerLeft,
        child: Text(
          drawerItem.name,
          style: TextStyle(
              color: drawerItem.selected ? Colors.black : Colors.white,
              fontSize: 26,
              fontFamily: 'Sofia Pro'),
        ),
        height: 70,
        width: 100,
        color: drawerItem.selected
            ? Theme.of(context).primaryColor
            : DwellColors.background,
      ),
    );
  }
}

class DwellDrawerTop extends StatelessWidget {
  const DwellDrawerTop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            child: Stack(
              children: [
                Transform.translate(
                  offset: Offset(-70, -40),
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.asset(
                      'assets/images/lamp.png',
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(-30, -30),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset(
                      'assets/images/droplet.png',
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
