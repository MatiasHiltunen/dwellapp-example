import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:flutter/material.dart';

import 'widgets/mainscreen_buttons.dart';
import 'widgets/pet_mainscreen.dart';
import 'widgets/consumption_clouds.dart';
import 'widgets/white_clouds.dart';
import '../pet/pet_selection_screen.dart';
import '../../widgets/common/dwell_app_bar.dart';
import '../../widgets/common/dwell_title.dart';
import '../../widgets/drawer.dart';

class MainScreenPage extends StatelessWidget {
  static const routeName = '/main_screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Log.error("main screen built.");
    return Scaffold(
      appBar: DwellAppBar(
          title: DwellTitle(
        title: S.of(context).mainscreenTitle,
        fontSize: 24,
      )),
      drawer: DwellDrawer(),
      body: Container(
        decoration: BoxDecoration(
          color: DwellColors.background,
        ),
        height: deviceSize.height,
        width: deviceSize.width,
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                const WhiteClouds(),
                ConsumptionCloudsMainScreen(),
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(PetSelectionScreen.routeName);
                  },
                  child: const PetMainScreen(),
                ),
              ],
            ),
            Spacer(),
            MainScreenButtons()
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
