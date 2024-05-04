import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/onboarding/onboarding_screen.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/tools/privacy.dart';
import 'package:Kuluma/tools/validations.dart';
import 'package:Kuluma/widgets/common/dwell_checkbox.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import '../../../widgets/common/dwell_orange_button.dart';
import '../../../widgets/common/dwell_title.dart';
import '../../../widgets/common/dwell_text_field.dart';
import 'dwell_backbutton.dart';

class DwellRegistrationForm extends StatefulWidget {
  final String registrationCode;
  final String lease;

  DwellRegistrationForm(this.registrationCode, this.lease);

  @override
  _DwellRegistrationFormState createState() => _DwellRegistrationFormState();
}

class _DwellRegistrationFormState extends State<DwellRegistrationForm> {
  final registrationFirstNameController = TextEditingController();
  final registrationLastNameController = TextEditingController();
  final registrationUsernameController = TextEditingController();
  final registrationPasswordController = TextEditingController();
  final registrationPasswordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _termsAccepted = false;

  void _register() async {
    if (text1 != text2 && InputValidations.validateStructure(text1)) return;
    setState(() {
      _loading = true;
    });

    Map registrationData = {
      "first_name": registrationFirstNameController.text.trim(),
      "last_name": registrationLastNameController.text.trim(),
      "username": registrationUsernameController.text.trim(),
      "password": registrationPasswordController.text.trim(),
      "code": widget.registrationCode,
      "lease": widget.lease
    };

    try {
      await Provider.of<User>(
        context,
        listen: false,
      ).registerNewUser(registrationData: registrationData);

      Navigator.of(context).pushReplacementNamed(Onboarding.routeName);
    } catch (e) {
      Log.error('Register new user error in widget: $e');
    }

    setState(() {
      _loading = false;
    });
  }

  bool _valid() {
    return text1 != null &&
        text2 != null &&
        _termsAccepted &&
        text1 == text2 &&
        InputValidations.validateStructure(text1) &&
        registrationFirstNameController.text.isNotEmpty &&
        registrationLastNameController.text.isNotEmpty &&
        registrationUsernameController.text.isNotEmpty;
  }

  void _toggleAccepted(bool val) {
    setState(() {
      _termsAccepted = val;
    });
  }

  String? text1;

  String? text2;

  @override
  void dispose() {
    registrationFirstNameController.dispose();
    registrationLastNameController.dispose();
    registrationUsernameController.dispose();
    registrationPasswordController.dispose();
    registrationPasswordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DwellDialog _dialog = DwellDialog(
      title: 'Tietosuojaseloste',
      content: Privacy.text,
      acceptText: "Ymmärrän ja hyväksyn tietojeni käsittelyn",
      cancelText: "Peruuta",
      onAccept: () => _toggleAccepted(true),
      onCancel: () => _toggleAccepted(false),
    );

    final s = S.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            DwellTitle(
              title: s.registerFormTitle,
            ),
            DwellTextFormField(
              inputController: registrationFirstNameController,
              errorOnEmpty: s.registerFormFirstNameOnEmpty,
              hint: s.registerFormFirstNameHint,
              hide: false,
            ),
            DwellTextFormField(
              inputController: registrationLastNameController,
              errorOnEmpty: s.registerFormLastNameOnEmpty,
              hint: s.registerFormLastNameHint,
              hide: false,
            ),
            DwellTextFormField(
              inputController: registrationUsernameController,
              errorOnEmpty: s.registerFormEmailOnEmpty,
              hint: s.registerFormEmailHint,
              hide: false,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: 80,
              width: constraints.maxWidth - 25,
              padding: EdgeInsets.fromLTRB(6, 6, 6, 6),
              child: Text(
                InputValidations.testPwd(text1, text2),
                style: TextStyle(
                  color: DwellColors.textWhite,
                  fontFamily: 'Sofia Pro',
                  fontSize: 12,
                ),
              ),
            ),
            DwellTextFormField(
              inputController: registrationPasswordConfirmController,
              errorOnEmpty: s.registerFormPasswordOnEmpty,
              hint: s.registerFormPasswordHint,
              hide: true,
              onChanged: (String text) {
                setState(() {
                  text1 = text;
                });
              },
            ),
            DwellTextFormField(
              inputController: registrationPasswordController,
              errorOnEmpty: s.registerFormPasswordOnEmpty,
              hint: s.registerFormPasswordHintConfirm,
              hide: true,
              onChanged: (String text) {
                setState(() {
                  text2 = text;
                });
              },
            ),
            Row(
              children: [
                DwellCheckBox(
                  value: _termsAccepted,
                  onTap: () => _toggleAccepted(!_termsAccepted),
                ),
                Container(
                  width: constraints.maxWidth - 50,
                  child: TextButton(
                    child: RichText(
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        text: 'Ymmärrän ja hyväksyn ',
                        style: TextStyle(
                            color: DwellColors.textWhite,
                            fontFamily: 'Sofia Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'tietosuojaselosteen',
                              style: TextStyle(color: DwellColors.primaryBlue)),
                          TextSpan(
                              text:
                                  ' sisällön. Tietojani saa käyttää sen mukaisesti'),
                        ],
                      ),
                    ),
                    onPressed: () => _dialog.show(context: context),
                  ),
                ),
              ],
            ),
            _loading
                ? SpinKitThreeBounce(
                    color: Colors.orange,
                  )
                : _valid()
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                            DwellOrangeButton(
                              text: s.registerFormButtonReady,
                              formKey: _formKey,
                              buttonPressed: _register,
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 20, bottom: 20, right: 15),
                        child: Text(
                          "Valmista",
                          style: TextStyle(
                            color: DwellColors.disabled,
                            fontFamily: 'Sofia Pro',
                            fontSize: 18,
                          ),
                        ),
                      ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: BackButtonInRegistration()),
            ),
          ],
        ),
      ),
    );
  }
}
