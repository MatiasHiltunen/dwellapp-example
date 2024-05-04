import 'package:Kuluma/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({
    Widget Function(BuildContext)? builder,
    RouteSettings? settings,
  }) : super(
          builder: builder ?? (context) => LoginScreen(),
          settings: settings,
        );

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
