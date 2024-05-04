import 'package:Kuluma/config.dart';

import '../screen_root.dart';
import 'package:flutter/material.dart';

class RouteNotFound extends StatefulWidget {
  static const routeName = '/error';

  @override
  _RouteNotFoundState createState() => _RouteNotFoundState();
}

class _RouteNotFoundState extends State<RouteNotFound> {
  @override
  Widget build(BuildContext context) {
    return ScreenRoot(
      title: 'Hups!',
      body: Container(
        color: DwellColors.background,
        child: Center(
            child: Text(
          "Hmm, tapahtui virhe.",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
