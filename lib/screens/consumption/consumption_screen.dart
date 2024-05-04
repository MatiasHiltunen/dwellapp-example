import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/screens/mainscreen/widgets/consumption_clouds.dart';
import 'package:Kuluma/widgets/common/dwell_layout_builder.dart';
import '../screen_root.dart';
import 'widgets/fl_chart.dart';
import 'package:flutter/material.dart';

import 'widgets/consumption_top_controls.dart';

class ConsumptionScreen extends StatefulWidget {
  static const routeName = '/consumption_screen';

  @override
  _ConsumptionScreenState createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {
  /*  static const Color water = Color(0xFF1AA7AC);
  static const Color energy = Color(0xFFEDBD4C); */

  Side side = Side.left;

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      side = ModalRoute.of(context)?.settings.arguments as Side;
    }

    return ScreenRoot(
      resizeToAvoidBottomInset: false,
      title: S.of(context).consumptionScreenTitle,
      body: DwellLayoutBuilder(
        child: Column(children: [
          ConsumptionScreenTopControls(
            color1: DwellColors.primaryBlue,
            color2: DwellColors.primaryYellow,
            side: side,
          ),
          DailyConsumptionChart(),
        ]),
        /*    optionalHeight: 603, */
      ),
    );
  }
}
