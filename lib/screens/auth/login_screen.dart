import 'package:Kuluma/config.dart';
import 'package:Kuluma/tools/utils.dart';

import 'package:flutter/material.dart';
import 'widgets/dwell_login_form.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Utils.dismissKeyboard(context),
        child: Container(
          alignment: Alignment.center,
          color: DwellColors.background,
          child: Login(),
        ),
      ),
      resizeToAvoidBottomInset: true,
      /*  bottomSheet: SnackBarLauncher(), */
    );
  }
}
