import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../../board/board_screen.dart';
import '../../consumption/consumption_screen.dart';

class MainScreenButtons extends StatelessWidget {
  const MainScreenButtons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ConsumptionScreen.routeName);
            },
            child: Container(
              alignment: Alignment.center,
              width: 130,
              height: 40,
              padding: EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                  color: DwellColors.primaryOrange,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20))),
              child: Text(
                S.of(context).mainscreenButtonConsumption,
                softWrap: true,
                style: TextStyle(
                    fontFamily: 'Sofia Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
          Transform.scale(
            scale: 1.1,
            child: SizedBox(
              width: 1.4,
              height: 36.3,
              child: _ButtonMiddleSeparator(),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(BoardScreen.routeName);
            },
            child: Container(
              alignment: Alignment.center,
              width: 130,
              height: 40,
              padding: EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                  color: DwellColors.primaryOrange,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              child: Text(
                S.of(context).mainscreenButtonBoard,
                style: TextStyle(
                    fontFamily: 'Sofia Pro',
                    fontSize: 20,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonMiddleSeparator extends StatelessWidget {
  const _ButtonMiddleSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(237, 151, 76, 1),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: DwellColors.textBlack,
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(237, 151, 76, 1),
            ),
          ),
        ),
      ],
    );
  }
}
