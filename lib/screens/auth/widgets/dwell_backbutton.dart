import 'package:Kuluma/generated/l10n.dart';
import 'package:flutter/material.dart';

import '../login_screen.dart';

class BackButtonInRegistration extends StatelessWidget {
  const BackButtonInRegistration({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(
            LoginScreen.routeName,
          );
        },
        child: Text(
          S.of(context).back,
          style: TextStyle(
            fontFamily: 'Sofia Pro',
            fontWeight: FontWeight.w500,
            fontSize: 17,
            color: Colors.white,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
