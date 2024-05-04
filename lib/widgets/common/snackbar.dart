import 'package:flutter/material.dart';

import '../../config.dart';

abstract class DwellSnackbar {
  static void displaySnackBar({
    required Duration duration,
    required String error,
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  }) {
    final snackBar = SnackBar(
      elevation: 5.0,
      margin: EdgeInsets.fromLTRB(32, 32, 32, 96),
      backgroundColor: DwellColors.textWhite,
      behavior: SnackBarBehavior.floating,
      content: Text(
        error,
        style: TextStyle(
          color: DwellColors.textBlack,
          // fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      action: SnackBarAction(
        label: 'OK',
        textColor: DwellColors.primaryOrange,
        onPressed: () {
          scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
        },
      ),
      duration: duration,
    );

    scaffoldMessengerKey.currentState!.hideCurrentSnackBar();
    scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }
}
