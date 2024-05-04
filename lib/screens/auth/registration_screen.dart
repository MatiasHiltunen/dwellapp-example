import 'package:Kuluma/config.dart';
import 'package:Kuluma/screens/auth/registration_code_check.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/tools/utils.dart';
import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';

import 'widgets/dwell_registration_form.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register_screen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegistrationMeta? args;

  final registrationCodeController = TextEditingController();

  @override
  void dispose() {
    registrationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as RegistrationMeta?;
    if (args == null)
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);

    Log.info(args?.code, args?.lease);

    Future<bool> _onBackPressed() async {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      return true;
    }

    final double h = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => Utils.dismissKeyboard(context),
          child: SingleChildScrollView(
            child: Container(
              height: h < 750 ? 750 : h,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: DwellColors.background,
              ),
              child: DwellRegistrationForm(
                args!.code,
                args!.lease,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
