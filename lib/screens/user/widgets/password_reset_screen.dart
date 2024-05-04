import 'package:Kuluma/providers/snackbar_provider.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/tools/utils.dart';
import 'package:Kuluma/tools/validations.dart';
import 'package:Kuluma/widgets/common/dwell_app_bar.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:Kuluma/widgets/common/dwell_orange_button_plain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dwell_grey_outlined_formfield.dart';
import '../../../config.dart';
import '../../../widgets/common/dwell_layout_builder.dart';

class PasswordResetScreen extends StatelessWidget {
  static const routeName = '/password_reset';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.dismissKeyboard(context);
      },
      child: Scaffold(
        appBar: DwellAppBar(
          disableActions: true,
          title: Text(
            'Salasanan vaihto',
            style: TextStyle(color: DwellColors.textWhite),
          ),
        ),
        body: DwellLayoutBuilder(
          child: PasswordChangeWidget(),
        ),
      ),
    );
  }
}

class PasswordChangeWidget extends StatefulWidget {
  const PasswordChangeWidget({
    Key? key,
  }) : super(key: key);

  @override
  _PasswordChangeWidgetState createState() => _PasswordChangeWidgetState();
}

class _PasswordChangeWidgetState extends State<PasswordChangeWidget> {
  TextEditingController pw1 = TextEditingController();
  TextEditingController pw2 = TextEditingController();

  String? text1;
  String? text2;

  @override
  void dispose() {
    pw1.dispose();
    pw2.dispose();
    super.dispose();
  }

  void savePwd(BuildContext context) {
    if (text1 == null ||
        text1 != text2 ||
        !InputValidations.validateStructure(text1)) return;

    Provider.of<User>(context, listen: false).apiPatch(
        endpoint: "account/password", data: {"password": text1}).then((value) {
      Provider.of<User>(context, listen: false).logout().then((_) {
        Navigator.of(context).pushReplacementNamed('/');
        Provider.of<SnackBarProvider>(context, listen: false).activateSnackBar(
            errorMessage: "Salasana vaihdettu onnistuneesti!");
      }).catchError((e) {
        Log.error(e);
      });
      Log.success(value);
    }).catchError((err) {
      Log.error("error changing password", err);
    });
  }

  @override
  Widget build(BuildContext context) {
    DwellDialog confirmDialog = DwellDialog(
      title: "Haluatko varmasti vaihtaa salasanasi?",
      content: 'Sinut kirjataan ulos kaikista laitteista',
      onAccept: () => savePwd(context),
    );

    return Column(
      children: [
        DwellGreyOutlinedTextFormField(
          controller: pw1,
          text: "Uusi salasana",
          hintText: '***********',
          obscureText: true,
          onChanged: (String text) {
            setState(() {
              text1 = text;
            });
          },
        ),
        DwellGreyOutlinedTextFormField(
          controller: pw2,
          text: "Uusi salasana uudelleen",
          hintText: '***********',
          obscureText: true,
          onChanged: (String text) {
            setState(() {
              text2 = text;
            });
          },
        ),
        Container(
          height: 150,
          padding: EdgeInsets.all(24),
          child: Text(
            InputValidations.testPwd(text1, text2),
            style: TextStyle(
                color: DwellColors.textWhite,
                fontFamily: 'Sofia Pro',
                fontSize: 16),
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                child: Text(
                  "Peruuta",
                  style: TextStyle(
                      color: DwellColors.textWhite,
                      fontFamily: 'Sofia Pro',
                      fontSize: 18),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Container(
              width: 110,
              child: text1 != null && text1 == text2
                  ? DwellOrangeButtonPlain(
                      buttonPressed: () => confirmDialog.show(context: context),
                      text: "Tallenna")
                  : Padding(
                      padding: const EdgeInsets.only(
                          left: 15, top: 7, bottom: 7, right: 15),
                      child: Text(
                        "Tallenna",
                        style: TextStyle(
                            color: DwellColors.disabled,
                            fontFamily: 'Sofia Pro',
                            fontSize: 18),
                      ),
                    ),
            )
          ],
        )
      ],
    );
  }
}
