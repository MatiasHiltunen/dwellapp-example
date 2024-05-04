import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:Kuluma/widgets/common/dwell_dialog.dart';

import '../../../tools/utils.dart';
import '../../../providers/board_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardTextField extends StatefulWidget {
  BoardTextField(
    this.controller, {
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<BoardTextField> createState() => _BoardTextFieldState();
}

class _BoardTextFieldState extends State<BoardTextField> {
  void _sendMessage(context) {
    Provider.of<BoardProvider>(context, listen: false)
        .sendMessage(widget.controller.text);
    widget.controller.clear();
    Utils.dismissKeyboard(context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      height: 80,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Container(
              height: 70,
              child: TextField(
                autofocus: false,
                controller: widget.controller,
                keyboardType: TextInputType.multiline,
                cursorHeight: 20,
                maxLines: 4,
                decoration: InputDecoration(
                    hintText: "Kirjoita uusi",
                    hintStyle: TextStyle(fontSize: 18),
                    contentPadding: EdgeInsets.only(top: 10, bottom: 10)),
                maxLength: context.read<User>().role == Role.admin.asString() ||
                        context.read<User>().role == Role.maintainer.asString()
                    ? 2000
                    : 300,
              ),
            ),
            width: width - 50,
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  DwellDialog confirm = DwellDialog(
                      title:
                          'Lähetetäänko ilmoitus viestistä kaikille käyttäjille?',
                      content:
                          "Kaikki käyttäjät saavat ilmoituksen viestistä ja ylläpidon ilmoitukset näkyvät myöhemmin myös uusille käyttäjille.",
                      acceptText: 'Kyllä',
                      cancelText: 'Ei',
                      onAccept: () {
                        Provider.of<BoardProvider>(context, listen: false)
                            .sendMessage(widget.controller.text,
                                adminNotifyAllUsers: true);
                        widget.controller.clear();
                        Utils.dismissKeyboard(context);
                      },
                      onCancel: () => _sendMessage(context));

                  String? userRole = context.read<User>().role;
                  Log.info(userRole);
                  if (userRole != null &&
                      (userRole == Role.admin.asString() ||
                          userRole == Role.maintainer.asString())) {
                    confirm.show(context: context);
                  } else {
                    _sendMessage(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(top: 5),
                  width: 50,
                  child: Image.asset(
                    "assets/images/send.png",
                    scale: 2,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
