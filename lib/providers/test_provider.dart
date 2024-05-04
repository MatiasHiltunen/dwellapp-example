import 'package:Kuluma/tools/logging.dart';
import 'package:flutter/foundation.dart';

import 'user_provider.dart';

class TestProvider extends ChangeNotifier {
  String asd = 'asd';
  late User _user;

  // User provider
  void update(user) {
    _user = user;
  }

  void testthis() {
    Log.success("data", _user.id);
  }
}
