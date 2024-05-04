import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/tools/privacy.dart';
import 'package:Kuluma/tools/utils.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../widgets/common/dwell_orange_button.dart';
import '../../../widgets/common/dwell_title.dart';
import '../../../tools/logging.dart';
import '../registration_code_check.dart';
import '../../../providers/user_provider.dart';
import '../../../widgets/common/dwell_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    setState(() {
      _loading = true;
      Utils.dismissKeyboard(context);
    });

    Map<String, String> _logindata = {
      'username': _usernameController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    try {
      await Provider.of<User>(
        context,
        listen: false,
      ).authenticate(
        _logindata['username'] ?? '',
        _logindata['password'] ?? '',
      );

      if (mounted) Navigator.of(context).pushReplacementNamed('/');
      return;
    } catch (e) {
      setState(() {
        _loading = false;
      });

      Log.warn("Wrong credentials", e);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        /*   headers: <String, String>{'my_header_key': 'my_header_value'}, */
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final b = MediaQuery.of(context).viewInsets.bottom;
    double h = MediaQuery.of(context).size.height;
/*     double w = MediaQuery.of(context).size.width;
    double val = (h - h / 3) - b / 3; */
/*     final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {} */
    return SingleChildScrollView(
      child: Container(
        height: h,
        width: MediaQuery.of(context).size.width,
/*         height: h + b,
        width: w, */
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              /*     duration: Duration(milliseconds: 200), */
              /*     height: 400, //val < 300 ? 300 : val, */
              /* width: 250, */
              /* constraints: BoxConstraints(minHeight: 300), */
              height: h / 1.6,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DwellTitle(
                      title: s.loginTitle,
                    ),
                    Container(
                      width: 250,
                      child: DwellTextFormField(
                        inputController: _usernameController,
                        hint: s.userName,
                        errorOnEmpty: s.userNameMissingError,
                        hide: false,
                      ),
                    ),
                    Container(
                      width: 250,
                      child: DwellTextFormField(
                        inputController: _passwordController,
                        hint: s.password,
                        errorOnEmpty: s.passwordMissing,
                        hide: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: _loading
                          ? SpinKitThreeBounce(
                              color: Colors.orange,
                            )
                          : DwellOrangeButton(
                              text: s.loginButton,
                              formKey: _formKey,
                              buttonPressed: _login,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            /*  Spacer(), */
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  s.passwordForgotten,
                  style: TextStyle(color: DwellColors.primaryBlue),
                ),
              ),
              onTap: () => _launchInBrowser(AppConfig.passwordResetUrl),
            ),
            /* TextButton(
              onPressed: () => _launchInBrowser(AppConfig.passwordResetUrl),
              child: Text(
                s.passwordForgotten,
                style: TextStyle(color: DwellColors.primaryBlue),
              ),
            ), */
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Tietosuoja",
                  style: TextStyle(color: DwellColors.primaryBlue),
                ),
              ),
              onTap: () =>
                  _launchInBrowser("https://dwell.frostbit.fi/privacy"),
            ),
            /* TextButton(
              onPressed: () {
                _launchInBrowser("https://dwell.frostbit.fi/privacy");
              },
              child: Text(
                "Tietosuoja",
                style: TextStyle(color: DwellColors.primaryBlue),
              ),
            ), */
            Spacer(),
            if (!_loading)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: RegistrationButtonInLogin(
                    text: s.registrationButtonInLogin),
              )
          ],
        ),
      ),
    );
  }
}

class RegistrationButtonInLogin extends StatelessWidget {
  final String text;
  const RegistrationButtonInLogin({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacementNamed(
          RegistrationCodeCheckScreen.routeName,
        );
      },
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Sofia Pro',
          fontWeight: FontWeight.w500,
          fontSize: 17,
          color: Colors.white,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
