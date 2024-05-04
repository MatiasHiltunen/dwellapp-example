import 'package:Kuluma/screens/onboarding/static/onboarding.dart';
import 'package:Kuluma/widgets/common/dwell_orange_button_plain.dart';
import 'package:flutter/material.dart';

import '../../../config.dart';

class OnboardingWidget extends StatelessWidget {
  const OnboardingWidget({Key? key, required this.s, required this.item})
      : super(key: key);

  final Size s;
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!item.bg)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: item.img,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 300,
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: DwellColors.primaryOrange,
                    fontSize: 22,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                width: s.width * 0.8,
                child: Text(
                  item.text,
                  style: TextStyle(
                    color: DwellColors.textWhite,
                    fontSize: 18,
                  ),
                ),
              )
            ],
          ),
          if (item.bg)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DwellOrangeButtonPlain(
                buttonPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                text: "Selvä!",
              ),
            ),
        ],
      ),
    );
  }
}
