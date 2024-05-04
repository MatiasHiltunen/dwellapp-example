import 'package:Kuluma/models/account.dart';
import 'package:Kuluma/providers/snackbar_provider.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/tools/utils.dart';

import 'package:Kuluma/widgets/common/dwell_app_bar.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dwell_grey_outlined_formfield.dart';
import '../../../config.dart';
import '../../../widgets/common/dwell_layout_builder.dart';
import 'user_info_bottom_controls.dart';

class EmailChangeScreen extends StatelessWidget {
  static const routeName = '/email_change';

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
            'Vaihda sähköpostiosoite',
            style: TextStyle(color: DwellColors.textWhite),
          ),
        ),
        body: DwellLayoutBuilder(
          child: EmailChange(),
        ),
      ),
    );
  }
}

class EmailChange extends StatefulWidget {
  const EmailChange({
    Key? key,
  }) : super(key: key);

  @override
  _EmailChangeState createState() => _EmailChangeState();
}

class _EmailChangeState extends State<EmailChange> {
  TextEditingController pw1 = TextEditingController();
  late Account currentAccount;

  String? text1;

  void save(BuildContext context) async {
    if (text1 == null) return;

    currentAccount = await Provider.of<User>(context, listen: false).account();

    Provider.of<User>(context, listen: false)
        .apiPut(endpoint: "account", data: {
      "first_name": currentAccount.firstName,
      "last_name": currentAccount.lastName,
      "username": text1
    }).then((value) {
      Provider.of<User>(context, listen: false).logout().then((_) {
        Navigator.of(context).pushReplacementNamed('/');
        Provider.of<SnackBarProvider>(context, listen: false).activateSnackBar(
            errorMessage: "Kirjautumistiedot päivitetty onnistuneesti!");
      }).catchError((e) {
        Log.error(e);
      });
      Log.success(value);
    }).catchError((err) {
      Log.error("error changing email", err);
    });
  }

  @override
  void dispose() {
    pw1.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DwellDialog confirmDialog = DwellDialog(
      title: "Haluatko varmasti vaihtaa sähköpostiosoitteesi?",
      content: 'Sinut kirjataan ulos kaikista laitteista',
      onAccept: () => save(context),
    );
    return Column(
      children: [
        DwellGreyOutlinedTextFormField(
          controller: pw1,
          text: "Uusi sähköpostiosoite",
          hintText: 'example@test.com',
          onChanged: (String text) {
            setState(() {
              text1 = text;
            });
          },
        ),
        Spacer(),
        UserInfoBottomControls(text1: text1, confirmDialog: confirmDialog)
      ],
    );
  }
}
