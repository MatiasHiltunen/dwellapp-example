import 'package:Kuluma/config.dart';
import 'package:flutter/material.dart';

class DwellAnimatedConsumptionText extends StatefulWidget {
  final bool selected;
  final String text;
  final Color color;
  DwellAnimatedConsumptionText(
      {Key? key,
      required this.selected,
      required this.color,
      required this.text})
      : super(key: key);

  @override
  _DwellAnimatedConsumptionTextState createState() =>
      _DwellAnimatedConsumptionTextState();
}

class _DwellAnimatedConsumptionTextState
    extends State<DwellAnimatedConsumptionText> {
  _DwellAnimatedConsumptionTextState();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        padding: EdgeInsets.all(widget.selected ? 3 : 4),
        height: 25,
        width: 45,
        child: FittedBox(
          child: Text(
            widget.text,
            style: TextStyle(
              color: widget.selected ? widget.color : DwellColors.textWhite,
              fontWeight: widget.selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        duration: Duration(milliseconds: 300));
  }
}
