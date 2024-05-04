import 'package:Kuluma/tools/logging.dart';
import 'package:flutter/material.dart';

class DwellTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  const DwellTitle({Key? key, required this.title, this.fontSize = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 220.0,
        child: Text(
          title,
          /* textScaleFactor: 1.2, */
          style: TextStyle(
            fontFamily: 'Sofia Pro Medium',
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
