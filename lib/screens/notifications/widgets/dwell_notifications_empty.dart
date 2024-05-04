import 'package:Kuluma/generated/l10n.dart';
import 'package:flutter/material.dart';

class DwellNotificationsEmpty extends StatelessWidget {
  const DwellNotificationsEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            S.of(context).notificationsEmpty,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
