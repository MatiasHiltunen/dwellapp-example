import 'package:flutter/material.dart';

class DwellTextFormField extends StatelessWidget {
  final TextEditingController inputController;
  final String hint;
  final String? errorOnEmpty;
  final bool hide;
  final Function(String)? onChanged;

  const DwellTextFormField({
    Key? key,
    required this.inputController,
    required this.hint,
    required this.hide,
    this.onChanged,
    this.errorOnEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        cursorColor: const Color.fromRGBO(26, 167, 172, 1),
        style: TextStyle(
          color: Colors.white,
        ),
        controller: inputController,
        cursorHeight: 20,
        decoration: InputDecoration(
          hintText: hint,
          isDense: true,
          contentPadding: EdgeInsets.only(top: 5),
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontFamily: 'Sofia Pro',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            decoration: TextDecoration.none,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromRGBO(26, 167, 172, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromRGBO(26, 167, 172, 1)),
          ),
          border: UnderlineInputBorder(
            borderSide:
                BorderSide(color: const Color.fromRGBO(26, 167, 172, 1)),
          ),
        ),
        obscureText: hide,
        validator: (value) {
          if (value != null && value.isEmpty && errorOnEmpty != null) {
            return errorOnEmpty;
          }
          return null;
        },
        onChanged: onChanged,
      ),
    );
  }
}
