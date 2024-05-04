import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final Text text;
  final Widget icon;
  TextIcon({required this.text, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: const EdgeInsets.only(left: 10.0),
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(right: 3.0), child: text),
          icon,
        ],
      ),
    );
  }
}
