import 'package:Kuluma/tools/common.dart';
import 'package:flutter/material.dart';

import '../../../config.dart';

class OnboardingPageIndicators extends StatelessWidget {
  const OnboardingPageIndicators({Key? key, required this.selected})
      : super(key: key);

  final BoardingItems selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 10,
                  width: 10,
                  decoration: BoxDecoration(
                    color: index == selected.index
                        ? DwellColors.primaryOrange
                        : DwellColors.textWhite,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
            itemCount: BoardingItems.values.length,
          ),
        )
      ],
    );
  }
}
