import '../../config.dart';
import '../screen_root.dart';
import 'package:flutter/material.dart';
import 'widgets/about_listview.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return ScreenRoot(
      title: 'Kuluma',
      body: Container(color: DwellColors.backgroundDark, child: DwellAboutListView()),
    );
  }
}
