import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tools/utils.dart';

import '../widgets/common/dwell_app_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/common/dwell_title.dart';

class ScreenRoot extends StatelessWidget {
  final Widget? bottomNavigationBar;
  final Widget? body;
  final String? title;
  final PreferredSizeWidget? appBar;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? floatingActionButton;
  final Widget? backButtonWhereTo;
  final bool allowBackbuttonScreenChange;
  final bool disableSnackbarLauncher;
  final bool? resizeToAvoidBottomInset;
  final Function? alternativeActionToBackButton;
  final Function? additionalOnWillPopFunction;

  ScreenRoot({
    this.bottomNavigationBar,
    this.title,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backButtonWhereTo,
    this.allowBackbuttonScreenChange = true,
    this.disableSnackbarLauncher = false,
    this.alternativeActionToBackButton,
    this.additionalOnWillPopFunction,
    this.resizeToAvoidBottomInset,
  });

  Future<bool> _onBackPressed(BuildContext context) async {
    if (additionalOnWillPopFunction != null) {
      additionalOnWillPopFunction!();
    }

    if (allowBackbuttonScreenChange) {
      // Navigator.of(context).pushReplacementNamed(MainScreenPage.routeName);
      Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
      // Navigator.of(context).pushReplacement(CustomPageRoute(builder: (_) => backButtonWhereTo ?? MainScreenPage()));

      return true;
    } else if (alternativeActionToBackButton != null) {
      alternativeActionToBackButton!();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool authStatus = Provider.of<User>(context).isAuth;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: GestureDetector(
        onTap: () {
          Log.info("dismiss keyboard from screen root");
          Utils.dismissKeyboard(context);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: appBar ?? DwellAppBar(title: DwellTitle(title: title ?? '')),
          drawer: authStatus ? DwellDrawer() : null,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButtonLocation: floatingActionButtonLocation,
          floatingActionButton: floatingActionButton,
          /*  bottomSheet: disableSnackbarLauncher ? SizedBox.shrink() : SnackBarLauncher(), */
        ),
      ),
    );
  }
}
