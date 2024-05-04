import 'dart:io';
import 'package:Kuluma/tools/logging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class DwellDialog {
  final String title;
  final String content;
  final String acceptText;
  final String cancelText;
  final Function? onAccept;
  final Function? onCancel;

  const DwellDialog({
    required this.title,
    required this.content,
    this.acceptText = "Ok",
    this.cancelText = "Peruuta",
    this.onAccept,
    this.onCancel,
  });

  Function get accept => onAccept ?? () => Log.success("ok pressed");
  Function get cancel => onCancel ?? () => Log.warn("cancelled");

  void show({context}) {
    showDialog(
      context: context,
      builder: (_) {
        if (kIsWeb) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  cancel();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(acceptText),
                onPressed: () {
                  accept();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        } else if (Platform.isIOS) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    cancel();
                    Navigator.of(context).pop();
                  },
                  child: Text(cancelText)),
              CupertinoDialogAction(
                  onPressed: () {
                    accept();
                    Navigator.of(context).pop();
                  },
                  child: Text(acceptText))
            ],
          );
        } else {
          return AlertDialog(
            title: Text(title),
            content:
                Container(child: SingleChildScrollView(child: Text(content))),
            actions: <Widget>[
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  cancel();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(acceptText),
                onPressed: () {
                  accept();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      },
    );
  }
}
