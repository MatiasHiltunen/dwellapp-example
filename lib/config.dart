import 'package:flutter/material.dart';

abstract class AppConfig {
  static const String apiBaseUrl = "https://dwelltest.frostbit.fi/api/";
  static const String passwordResetUrl =
      "https://dwell.frostbit.fi/#/password/forgotten";
  static const bool loggingEnabled = false;
  static const bool useDummyData = false;

  static String getUrl(String endpoint) => '$apiBaseUrl$endpoint';
}

abstract class DwellColors {
  static const Map<int, Color> colorCodes = {
    50: Color.fromRGBO(237, 151, 76, .1),
    100: Color.fromRGBO(237, 151, 76, .2),
    200: Color.fromRGBO(237, 151, 76, .3),
    300: Color.fromRGBO(237, 151, 76, .4),
    400: Color.fromRGBO(237, 151, 76, .5),
    500: Color.fromRGBO(237, 151, 76, .6),
    600: Color.fromRGBO(237, 151, 76, .7),
    700: Color.fromRGBO(237, 151, 76, .8),
    800: Color.fromRGBO(237, 151, 76, .9),
    900: Color.fromRGBO(237, 151, 76, 1),
  };

  /// Taustaväri
  // static const Color background = Color(0xFF11414A);
  static const Color background = Color(0xFF0D3C4C);

  /// Tummennettu pohjaväri
  static const Color backgroundDark = Color(0xFF0B3341);

  /// -”Kirjoita uusi”
  /// Tekstinsyöttöpalkin pohjaväri
  static const Color backgroundWhite = Color(0xFFF2F2F2);

  /// Korosteväri 1
  /// -APPbar
  /// -Napit
  static const Color primaryOrange = Color(0xFFED974C);

  /// Korosteväri 2
  /// -Graafiset elementit -Vedenkulutus
  static const Color primaryBlue = Color(0xFF1AA7AC);

  /// Korosteväri 3
  /// -Graafiset elementit
  /// -Sähkönkulutus
  static const Color primaryYellow = Color(0xFFEDBF4C);

  /// Nappi
  /// -disabled tekstin väri
  static const Color disabled = Color(0xFF575757);

  /// Kommenttien ja tykkäysten määrä
  static const Color countIndicatorColor = Color(0xFFA3B5B9);

  /// Nappi
  /// -Disabled pohjaväri
  /// -Valinnan väri valikossa
  /// -Häivytetyn tekstin väri valkealla taustalla (tekstinsyöttö)
  static const Color backgroundLight = Color(0xFFAEAEAE);

  /// Teksti
  /// -Dropshadow 30% graafisissa elementeissä
  static const Color textBlack = Color(0xFF000000);

  /// Taustaväri palstalla
  static const Color boardBackground = Color(0xFFE2E2E2);

  /// Teksti, ikonit, hahmo
  static const Color textWhite = Color(0xFFFFFFFF);
}
