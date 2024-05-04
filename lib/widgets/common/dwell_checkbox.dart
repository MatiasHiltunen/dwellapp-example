import 'package:Kuluma/config.dart';
import 'package:flutter/material.dart';

class DwellCheckBox extends StatelessWidget {
  final Function() onTap;
  final bool value;

  const DwellCheckBox({
    Key? key,
    required this.value,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 25,
              height: 20,
              child: Stack(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: DwellColors.primaryOrange, width: 2),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(2, -3),
                    child: Transform.scale(
                      scale: 0.9,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 100),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                              child: child, scale: animation);
                        },
                        child: value
                            ? Image(
                                image:
                                    AssetImage("assets/images/orange_tick.png"),
                              )
                            : SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
