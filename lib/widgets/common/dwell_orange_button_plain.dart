import 'package:flutter/material.dart';

class DwellOrangeButtonPlain extends StatelessWidget {
  final Function() buttonPressed;
  final String text;

  const DwellOrangeButtonPlain({
    Key? key,
    required this.buttonPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: buttonPressed,
      padding: const EdgeInsets.only(left: 15, top: 7, bottom: 7, right: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      textColor: Colors.black,
      color: const Color.fromRGBO(237, 151, 76, 1),
      child: Container(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Sofia Pro',
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }
}
