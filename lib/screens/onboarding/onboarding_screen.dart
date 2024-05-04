import 'package:flutter/material.dart';

import '../../config.dart';
import '../../tools/common.dart';
import 'widgets/onboarding_page_indicators.dart';
import 'widgets/onboarding_widget.dart';
import 'static/onboarding.dart';

class Onboarding extends StatefulWidget {
  static const routeName = '/onboarding_screen';

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  BoardingItems _selected = BoardingItems.welcome;

  void swipe(DragEndDetails details) {
    double v = details.primaryVelocity!;
    if (v.abs() < 500) return;

    if (!v.isNegative && _selected.index != 0) {
      setState(() {
        _selected = BoardingItems.values[_selected.index - 1];
      });
    } else if (v.isNegative &&
        _selected.index != BoardingItems.values.last.index) {
      setState(() {
        _selected = BoardingItems.values[_selected.index + 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: swipe,
        child: Container(
          width: s.width,
          height: s.height,
          decoration: BoxDecoration(
            image: _selected != BoardingItems.introduction
                ? null
                : DecorationImage(
                    image: AssetImage("assets/images/intro_bg.png"),
                    colorFilter: ColorFilter.mode(
                      DwellColors.background,
                      BlendMode.dstATop,
                    ),
                    fit: BoxFit.cover,
                  ),
            color: _selected != BoardingItems.introduction
                ? DwellColors.background
                : null,
          ),
          child: SingleChildScrollView(
            child: Container(
              height: s.height > 750 ? s.height : 750,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.of(context).pushReplacementNamed('/'),
                          child: Icon(
                            Icons.close,
                            size: 35,
                            color: DwellColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OnboardingWidget(
                    key: UniqueKey(),
                    s: s,
                    item: OnboardingItems.items[_selected.index],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: OnboardingPageIndicators(
                      selected: _selected,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
