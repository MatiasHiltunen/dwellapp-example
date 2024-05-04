import 'package:Kuluma/widgets/common/dwell_dialog.dart';
import 'package:Kuluma/widgets/common/dwell_orange_button_plain.dart';
import 'package:flutter/material.dart';

import '../../../config.dart';

class UserInfoBottomControls extends StatelessWidget {
  const UserInfoBottomControls({
    Key? key,
    required this.text1,
    required this.confirmDialog,
    this.alternativeText,
  }) : super(key: key);

  final String? text1;
  final DwellDialog confirmDialog;
  final String? alternativeText;

  @override
  Widget build(BuildContext context) {
    return Row(
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
          child: text1 != null
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
    );
  }
}
