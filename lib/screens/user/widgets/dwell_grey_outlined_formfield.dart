import 'package:flutter/material.dart';

import '../../../config.dart';

class DwellGreyOutlinedTextFormField extends StatelessWidget {
  const DwellGreyOutlinedTextFormField({
    Key? key,
    required this.controller,
    required this.text,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String)? onChanged;
  final String text;
  final bool obscureText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: EdgeInsets.only(top: 24, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              text,
              style: TextStyle(
                color: DwellColors.primaryOrange,
                fontSize: 20,
                fontFamily: 'Sofia Pro',
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          TextFormField(
            onChanged: onChanged,
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
                isDense: true,
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: DwellColors.backgroundLight, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: DwellColors.backgroundLight, width: 1.0),
                ),
                hintText: hintText,
                hintStyle: TextStyle(color: DwellColors.backgroundLight),
                contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 10)),
            style: TextStyle(color: DwellColors.backgroundLight),
          ),
        ],
      ),
    );
  }
}
