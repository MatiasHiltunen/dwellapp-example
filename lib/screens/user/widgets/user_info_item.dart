import 'package:flutter/material.dart';

import '../../../config.dart';

class UserInfoItem extends StatelessWidget {
  const UserInfoItem({
    Key? key,
    required this.title,
    this.text,
  }) : super(key: key);

  final String title;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            title,
            style: TextStyle(
              color: DwellColors.primaryOrange,
              fontSize: 20,
              fontFamily: 'Sofia Pro',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (text != null)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              text ?? '',
              style: TextStyle(
                  color: DwellColors.textWhite,
                  fontSize: 18,
                  fontFamily: 'Sofia Pro'),
            ),
          ),
      ],
    );
  }
}
