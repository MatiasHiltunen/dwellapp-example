import 'package:Kuluma/widgets/common/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarProvider with ChangeNotifier {
  GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  SnackBarProvider(this.scaffoldMessengerKey);

  void activateSnackBar({
    required String errorMessage,
    int displayDuration = 3,
  }) {
    DwellSnackbar.displaySnackBar(
      duration: Duration(seconds: displayDuration),
      error: errorMessage,
      scaffoldMessengerKey: scaffoldMessengerKey,
    );
  }
}
