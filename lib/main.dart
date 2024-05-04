import 'package:flare_flutter/flare_cache.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'providers/entry_provider.dart';
import 'providers/snackbar_provider.dart';
import 'providers/user_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/board_provider.dart';

import 'models/board_item.dart';
import 'models/entry_avg.dart';
import 'models/entry_cache.dart';
import 'models/user.dart';

import 'widgets/dwell_material_app.dart';
import 'widgets/common/pets_flare_actor.dart';

import 'config.dart';

void main() async {
  FlareCache.doesPrune = false;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(EntryCacheAdapter());
    Hive.registerAdapter(AvgAdapter());
    Hive.registerAdapter(BoardItemAdapter());

    var box = await Hive.openBox('db');
    await Pets.warmUpFlare();
    runApp(MyApp(box));
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  final Box<dynamic> database;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  MyApp(this.database);

  @override
  Widget build(BuildContext context) {
    MaterialColor customColor =
        MaterialColor(0xFFED974C, DwellColors.colorCodes);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotificationProvider(),
        ),
        ChangeNotifierProvider<SnackBarProvider>(
          create: (_) => SnackBarProvider(scaffoldMessengerKey),
        ),
        ChangeNotifierProxyProvider2<NotificationProvider, SnackBarProvider,
                User>(
            create: (_) => User(database),
            update: (_, NotificationProvider nProvider,
                SnackBarProvider sProvider, User? uProvider) {
              return uProvider!
                ..update(sProvider.activateSnackBar, nProvider.clear);
            }),
        ChangeNotifierProxyProvider<User, BoardProvider>(
          create: (_) => BoardProvider(),
          update: (_, User uProvider, BoardProvider? bProvider) =>
              bProvider!..update(uProvider),
        ),
        ChangeNotifierProxyProvider<User, EntryProvider>(
          create: (_) => EntryProvider(),
          update: (_, User uProvider, EntryProvider? eProvider) =>
              eProvider!..update(uProvider),
        ),
      ],
      child: DwellMaterialApp(
        customColor: customColor,
        scaffoldMessengerKey: scaffoldMessengerKey,
      ),
    );
  }
}
