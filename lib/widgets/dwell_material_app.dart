import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/about/about_screen.dart';
import 'package:Kuluma/screens/action_log/action_log_screen.dart';
import 'package:Kuluma/screens/auth/login_screen.dart';
import 'package:Kuluma/screens/auth/registration_code_check.dart';
import 'package:Kuluma/screens/auth/registration_screen.dart';
import 'package:Kuluma/screens/board/board_item_view_screen.dart';
import 'package:Kuluma/screens/board/board_screen.dart';
import 'package:Kuluma/screens/consumption/consumption_screen.dart';
import 'package:Kuluma/screens/error/error_screen.dart';
import 'package:Kuluma/screens/mainscreen/main_screen.dart';
import 'package:Kuluma/screens/notifications/notifications_screen.dart';
import 'package:Kuluma/screens/onboarding/onboarding_screen.dart';
import 'package:Kuluma/screens/pet/pet_selection_screen.dart';
import 'package:Kuluma/screens/user/user_screen.dart';
import 'package:Kuluma/screens/user/widgets/delete_account.dart';
import 'package:Kuluma/screens/user/widgets/email_change_screen.dart';
import 'package:Kuluma/screens/user/widgets/name_change_screen.dart';
import 'package:Kuluma/screens/user/widgets/password_reset_screen.dart';
import 'package:Kuluma/tools/custom_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

class DwellMaterialApp extends StatefulWidget {
  DwellMaterialApp({
    Key? key,
    required this.customColor,
    required this.scaffoldMessengerKey,
  }) : super(key: key);

  final MaterialColor customColor;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  @override
  _DwellMaterialAppState createState() => _DwellMaterialAppState();
}

class _DwellMaterialAppState extends State<DwellMaterialApp> {
  CustomPageRoute generateRoutes(
    RouteSettings settings,
  ) {
    Map<String, Widget Function(BuildContext)> routes = {
      MainScreenPage.routeName: (context) => MainScreenPage(),
      PetSelectionScreen.routeName: (context) => PetSelectionScreen(),
      ConsumptionScreen.routeName: (context) => ConsumptionScreen(),
      RegisterScreen.routeName: (context) => RegisterScreen(),
      RegistrationCodeCheckScreen.routeName: (context) =>
          RegistrationCodeCheckScreen(),
      LoginScreen.routeName: (context) => LoginScreen(),
      NotificationsScreen.routeName: (context) => NotificationsScreen(),
      BoardScreen.routeName: (context) => BoardScreen(),
      BoardItemViewScreen.routeName: (context) => BoardItemViewScreen(),
      AboutScreen.routeName: (context) => AboutScreen(),
      UserScreen.routeName: (context) => UserScreen(),
      Onboarding.routeName: (context) => Onboarding(),
      PasswordResetScreen.routeName: (context) => PasswordResetScreen(),
      EmailChangeScreen.routeName: (context) => EmailChangeScreen(),
      NameChangeScreen.routeName: (context) => NameChangeScreen(),
      AccountDelete.routeName: (context) => AccountDelete(),
      ActionLogScreen.routeName: (context) => ActionLogScreen(),
      'error': (context) => RouteNotFound(),
      '/': (context) =>
          Provider.of<User>(context).isAuth ? MainScreenPage() : LoginScreen()
    };

    if (!routes.keys.contains(settings.name))
      return CustomPageRoute(builder: routes['error']);
    return CustomPageRoute(
      builder: routes[settings.name],
      settings:
          RouteSettings(name: settings.name, arguments: settings.arguments),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => S.of(context).appTitle,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
          textTheme: ThemeData.light().textTheme.copyWith(
                button: TextStyle(color: Colors.white),
              ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: widget.customColor,
          ).copyWith(secondary: Colors.grey),
          primaryColor: widget.customColor),
      initialRoute: '/',
      onGenerateRoute: generateRoutes,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: widget.scaffoldMessengerKey,
    );
  }
}
