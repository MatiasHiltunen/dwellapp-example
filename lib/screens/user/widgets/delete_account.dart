import 'package:Kuluma/providers/snackbar_provider.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/action_log/action_log_screen.dart';
import 'package:Kuluma/screens/user/widgets/user_info_bottom_controls.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/tools/utils.dart';
import 'package:Kuluma/widgets/common/dwell_app_bar.dart';
import 'package:Kuluma/widgets/common/dwell_checkbox.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:Kuluma/widgets/common/dwell_layout_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config.dart';
import 'dwell_grey_outlined_formfield.dart';
import 'user_info_item.dart';

class AccountDelete extends StatelessWidget {
  static const routeName = '/account_delete';

  final String text =
      """Poistaessasi käyttäjätilin luomasi sisällöt jäävät voimaan palstalle, jos et niitä erikseen poista. Jotta yhteisesti jaettu tieto jäisi edelleen muiden asukkaiden käyttöön, toivomme että ne voitaisiin säilyttää alkuperäisessä muodossaan. 

Jos kuitenkin haluat poistaa laatimaasi sisältöä, voit selata ja poistaa sitä tomintaloki-osiosta ennen käyttäjätilin sulkua:
""";

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
            'Käyttäjätilin poisto',
            style: TextStyle(color: DwellColors.textWhite),
          ),
        ),
        body: DwellLayoutBuilder(
          child: AccountDeleteBody(text: text),
          optionalHeight: 760,
        ),
      ),
    );
  }
}

class AccountDeleteBody extends StatefulWidget {
  const AccountDeleteBody({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  _AccountDeleteBodyState createState() => _AccountDeleteBodyState();
}

class _AccountDeleteBodyState extends State<AccountDeleteBody> {
  bool _termsAccepted = false;
  TextEditingController pw1 = TextEditingController();
  String? text1;

  void _toggleAccepted(bool val) {
    setState(() {
      _termsAccepted = val;
    });
  }

  void _deleteAccount() {
    Provider.of<User>(context, listen: false).apiPost(
        endpoint: "/account/remove", data: {"password": text1}).then((value) {
      Log.success("account deleted", value);
      Provider.of<User>(context, listen: false).logout().then((_) {
        Navigator.of(context).pushReplacementNamed('/');
        Provider.of<SnackBarProvider>(context, listen: false).activateSnackBar(
            errorMessage:
                "Käyttäjätili poistettu onnistuneesti. Sorry to see you go :/");
      }).catchError((e) {
        Log.error(e);
      });
    }).catchError((e) {
      Provider.of<SnackBarProvider>(context, listen: false)
          .activateSnackBar(errorMessage: "Tarkista salasana");
    });
  }

  @override
  Widget build(BuildContext context) {
    final DwellDialog dwellDialog = DwellDialog(
        title: "Haluatko varmasti poistaa käyttäjätilisi?",
        content:
            "Tilisi kaikki tiedot menetetään pysyvästi, asuntosi kulutusdataa sekä Palstalle jättämiäsi viestäjä lukuunottamatta. \n\nKulutusdatan hallintaan liittyvissä asioissa ole yhteydessä tukeen: \n\ndasaspa@das.fi",
        onAccept: () {
          _deleteAccount();
        });
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: UserInfoItem(title: "Tiedoksi", text: widget.text),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(ActionLogScreen.routeName);
        },
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              UserInfoItem(title: "Toimintaloki"),
              Icon(
                Icons.arrow_forward_ios,
                color: DwellColors.primaryOrange,
              )
            ],
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: DwellCheckBox(
              value: _termsAccepted,
              onTap: () => _toggleAccepted(!_termsAccepted),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                "Olen poistanut sisällöt, joiden en toivo jäävän sovellukeen.",
                style: TextStyle(
                  color: DwellColors.textWhite,
                  fontFamily: 'Sofia Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
          )
        ],
      ),
      DwellGreyOutlinedTextFormField(
        controller: pw1,
        text: "Varmenna poisto salasanalla",
        hintText: '***********',
        obscureText: true,
        onChanged: (String text) {
          setState(() {
            text1 = text;
          });
        },
      ),
      Spacer(),
      UserInfoBottomControls(
          text1: _termsAccepted && text1 != null && text1!.length > 5
              ? text1!
              : null,
          confirmDialog: dwellDialog)
    ]);
  }
}
