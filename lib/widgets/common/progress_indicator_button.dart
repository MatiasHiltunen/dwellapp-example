/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorButton extends StatelessWidget {
  final bool isLoading;
  final bool enabled;
  final Function callback;

  ProgressIndicatorButton({this.isLoading, this.enabled, this.callback});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          )
        : FlatButton.icon(
            onPressed: enabled ? callback : null,
            icon: Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
            label: Text(
              'Tallenna',
              style: TextStyle(color: Colors.white),
            ),
          );
  }
}
 */
