import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/screens/auth/registration_screen.dart';
import 'package:Kuluma/tools/utils.dart';
import 'package:Kuluma/widgets/common/dwell_orange_button.dart';
import 'package:Kuluma/widgets/common/dwell_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import '../../providers/user_provider.dart';
import 'widgets/dwell_backbutton.dart';

class RegistrationCodeCheckScreen extends StatefulWidget {
  static const routeName = '/registration_code_check_screen';

  @override
  _RegistrationCodeCheckScreenState createState() =>
      _RegistrationCodeCheckScreenState();
}

class RegistrationMeta {
  final String lease;
  final String code;
  RegistrationMeta(this.lease, this.code);
}

class _RegistrationCodeCheckScreenState
    extends State<RegistrationCodeCheckScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  String? _lease;
  String? _registrationCode;
  bool infoClicked = false;

  final registrationCodeController = TextEditingController();

  void _checkRegistrationCode() async {
    setState(() {
      _loading = true;
    });

    _registrationCode = registrationCodeController.text.trim();

    _lease = await Provider.of<User>(
      context,
      listen: false,
    ).checkRegistrationCode(_registrationCode);

    // Log.info("lease", _lease);

    if (_lease != null && _registrationCode != null) {
      Navigator.of(context).pushReplacementNamed(
        RegisterScreen.routeName,
        arguments: RegistrationMeta(_lease!, _registrationCode!),
      );
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    registrationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() async {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      return true;
    }

    final s = S.of(context);
    final double h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: GestureDetector(
          onTap: () => Utils.dismissKeyboard(context),
          child: SingleChildScrollView(
            child: Container(
              height: h,
              decoration: BoxDecoration(
                color: DwellColors.background,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: DwellTitle(
                        title: s.register,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: RegistrationCodeTextField(
                        registrationCodeController: registrationCodeController,
                        s: s,
                      ),
                    ),
                  ),
                  _loading
                      ? Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: SpinKitThreeBounce(
                            color: Colors.orange,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: <Widget>[
                              DwellOrangeButton(
                                formKey: _formKey,
                                buttonPressed: _checkRegistrationCode,
                                text: s.next,
                              ),
                            ],
                          ),
                        ),
                  TextButton(
                    child: Text(
                      s.howToGetCode,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        infoClicked = !infoClicked;
                      });
                    },
                  ),
                  Center(
                    child: Text(
                      infoClicked ? s.registrationCodeCheckInfo : '',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  !_loading
                      ? Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: BackButtonInRegistration()),
                        )
                      : Expanded(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox.shrink(),
                              )),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationCodeTextField extends StatelessWidget {
  const RegistrationCodeTextField({
    Key? key,
    required this.registrationCodeController,
    required this.s,
  }) : super(key: key);

  final TextEditingController registrationCodeController;
  final S s;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,
        ),
        controller: registrationCodeController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
          hintText: s.activationCode,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontFamily: 'Sofia Pro',
            fontWeight: FontWeight.w300,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return s.activationCodeValidate;
          }
          return null;
        },
      ),
    );
  }
}
