import 'package:Kuluma/models/account.dart';
import 'package:Kuluma/providers/snackbar_provider.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/tools/utils.dart';

import 'package:Kuluma/widgets/common/dwell_app_bar.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:Kuluma/widgets/common/dwell_orange_button_plain.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dwell_grey_outlined_formfield.dart';
import '../../../config.dart';
import '../../../widgets/common/dwell_layout_builder.dart';

class NameChangeScreen extends StatelessWidget {
  static const routeName = '/name_change';

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
            'Vaihda nimeä',
            style: TextStyle(color: DwellColors.textWhite),
          ),
        ),
        body: DwellLayoutBuilder(
          child: NameChange(),
        ),
      ),
    );
  }
}

class NameChange extends StatefulWidget {
  const NameChange({
    Key? key,
  }) : super(key: key);

  @override
  _NameChangeState createState() => _NameChangeState();
}

class _NameChangeState extends State<NameChange> {
  TextEditingController pw1 = TextEditingController();
  TextEditingController pw2 = TextEditingController();

  late Account currentAccount;

  String? text1;
  String? text2;

  void save(BuildContext context) async {
    Provider.of<User>(context, listen: false)
        .apiPut(endpoint: "account", data: {
      "first_name": pw1.text,
      "last_name": pw2.text,
      "username": currentAccount.userName
    }).then((value) {
      Provider.of<SnackBarProvider>(context, listen: false)
          .activateSnackBar(errorMessage: "Nimi päivitetty onnistuneesti!");
      Navigator.of(context).pop();
      Log.success(value);
    }).catchError((err) {
      Log.error("error changing email", err);
    });
  }

  @override
  void dispose() {
    pw1.dispose();
    pw2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DwellDialog confirmDialog = DwellDialog(
      title: "Haluatko varmasti muuttaa nimeäsi?",
      content:
          'Oikeaa nimeäsi käyttämällä helpotat ylläpidon tehtäviä :) \n\nNimesi ei näy muille asukkaille.',
      onAccept: () => save(context),
    );

    currentAccount = Provider.of<User>(context, listen: false).accountDataSync!;

    if (pw1.text == '' || pw2.text == '') {
      pw1.text = currentAccount.firstName;
      pw2.text = currentAccount.lastName;
    }

    return Column(
      children: [
        DwellGreyOutlinedTextFormField(
          controller: pw1,
          text: "Etunimi",
          hintText: '',
        ),
        DwellGreyOutlinedTextFormField(
          controller: pw2,
          text: "Sukunimi",
          hintText: '',
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
                    fontSize: 18,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Container(
              width: 110,
              child: pw1.text.length > 1 && pw2.text.length > 1
                  ? DwellOrangeButtonPlain(
                      buttonPressed: () => confirmDialog.show(context: context),
                      text: "Tallenna",
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        top: 7,
                        bottom: 7,
                        right: 15,
                      ),
                      child: Text(
                        "Tallenna",
                        style: TextStyle(
                          color: DwellColors.disabled,
                          fontFamily: 'Sofia Pro',
                          fontSize: 18,
                        ),
                      ),
                    ),
            )
          ],
        )
      ],
    );
  }
}
