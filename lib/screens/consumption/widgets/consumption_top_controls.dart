import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/screens/mainscreen/widgets/consumption_clouds.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/entry_provider.dart';
import 'dwell_consumption_text_animated.dart';
import 'dwell_toggle_animated.dart';

class ConsumptionScreenTopControls extends StatefulWidget {
  final Color color1;
  final Color color2;
  final Side side;
  const ConsumptionScreenTopControls({
    required this.color1,
    required this.color2,
    required this.side,
    Key? key,
  }) : super(key: key);

  @override
  _ConsumptionScreenTopControlsState createState() =>
      _ConsumptionScreenTopControlsState(side == Side.right);
}

class _ConsumptionScreenTopControlsState
    extends State<ConsumptionScreenTopControls> {
  bool val = false;
  bool housingAverage = false;
  final bool initialValue;

  _ConsumptionScreenTopControlsState(this.initialValue);

  @override
  void initState() {
    super.initState();
    val = initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: DwellColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black87,
              offset: Offset(
                0.0,
                0.6,
              ),
              blurRadius: 2.0,
            ),
          ],
        ),
        width: deviceSize.width,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DwellAnimatedConsumptionText(
              text: S.of(context).consumptionTopControlsWater,
              selected: !val,
              color: widget.color1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DwellToggle(
                  status: (bool value) {
                    setState(() {
                      val = value;
                    });
                    Provider.of<EntryProvider>(context, listen: false)
                        .toggleSelectedSensor(val);
                  },
                  left: widget.color1,
                  rigth: widget.color2,
                  initialState: val),
            ),
            DwellAnimatedConsumptionText(
              text: S.of(context).consumptionTopControlsEnergy,
              selected: val,
              color: widget.color2,
            ),
            /* Container(
              width: 50,
            ), */
            /* DwellConsumptionCheckBox(
              switchColor: housingAverage,
              value: val,
              onTap: () => setState(() {
                housingAverage = !housingAverage;
                Provider.of<EntryProvider>(context, listen: false)
                    .avgOfAllCheck = housingAverage;
              }),
              text: "Kelo",
              textStyle: TextStyle(fontSize: 15),
            ), */
          ],
        ),
      ),
    );
  }
}
