import 'package:Kuluma/widgets/common/dwell_orange_button_plain.dart';
import 'package:flutter/material.dart';

class DwellOrangeButton extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final Function buttonPressed;
  final String text;
  final TextEditingController? controller;

  const DwellOrangeButton({
    Key? key,
    required GlobalKey<FormState> formKey,
    required this.buttonPressed,
    required this.text,
    this.controller,
  })  : _formKey = formKey,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return DwellOrangeButtonPlain(
        buttonPressed: () {
          if (_formKey.currentState!.validate() && controller != null)
            buttonPressed(controller?.text);
          else if (_formKey.currentState!.validate()) buttonPressed();
        },
        text: text);
  }
}
