import 'package:flutter/material.dart';

class DwellConsumptionCheckBox extends StatelessWidget {
  final Function() onTap;
  final bool switchColor;
  final bool value;
  final String text;
  final TextStyle textStyle;

  const DwellConsumptionCheckBox({
    Key? key,
    required this.switchColor,
    required this.value,
    required this.onTap,
    required this.text,
    required this.textStyle,
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
              child: Stack(children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.black38),
                ),
                Transform.translate(
                  offset: Offset(2, -3),
                  child: Transform.scale(
                    scale: 0.9,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 100),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: switchColor
                          ? Image(
                              image: value
                                  ? AssetImage("assets/images/check_orange.png")
                                  : AssetImage("assets/images/check_blue.png"),
                            )
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
