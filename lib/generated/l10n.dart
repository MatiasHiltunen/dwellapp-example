// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Kuluma`
  String get appTitle {
    return Intl.message(
      'Kuluma',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginTitle {
    return Intl.message(
      'Login',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get userName {
    return Intl.message(
      'Username',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Username missing.`
  String get userNameMissingError {
    return Intl.message(
      'Username missing.',
      name: 'userNameMissingError',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Password missing.`
  String get passwordMissing {
    return Intl.message(
      'Password missing.',
      name: 'passwordMissing',
      desc: '',
      args: [],
    );
  }

  /// `To Kuluma`
  String get loginButton {
    return Intl.message(
      'To Kuluma',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registrationButtonInLogin {
    return Intl.message(
      'Register',
      name: 'registrationButtonInLogin',
      desc: '',
      args: [],
    );
  }

  /// `Protecting your privacy is important!\n\nTo view your home's usage data, you'll need a code from DAS to activate it. The application will initially be tested only with DAS Kello residents.`
  String get registrationCodeCheckInfo {
    return Intl.message(
      'Protecting your privacy is important!\n\nTo view your home\'s usage data, you\'ll need a code from DAS to activate it. The application will initially be tested only with DAS Kello residents.',
      name: 'registrationCodeCheckInfo',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Activation code`
  String get activationCode {
    return Intl.message(
      'Activation code',
      name: 'activationCode',
      desc: '',
      args: [],
    );
  }

  /// `Activation code can't be empty`
  String get activationCodeValidate {
    return Intl.message(
      'Activation code can\'t be empty',
      name: 'activationCodeValidate',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `How do I get the code?`
  String get howToGetCode {
    return Intl.message(
      'How do I get the code?',
      name: 'howToGetCode',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get registerFormTitle {
    return Intl.message(
      'Register',
      name: 'registerFormTitle',
      desc: '',
      args: [],
    );
  }

  /// `Firstname can not be empty`
  String get registerFormFirstNameOnEmpty {
    return Intl.message(
      'Firstname can not be empty',
      name: 'registerFormFirstNameOnEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Firstname`
  String get registerFormFirstNameHint {
    return Intl.message(
      'Firstname',
      name: 'registerFormFirstNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Lastname can not be empty`
  String get registerFormLastNameOnEmpty {
    return Intl.message(
      'Lastname can not be empty',
      name: 'registerFormLastNameOnEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Lastname`
  String get registerFormLastNameHint {
    return Intl.message(
      'Lastname',
      name: 'registerFormLastNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Email can not be empty`
  String get registerFormEmailOnEmpty {
    return Intl.message(
      'Email can not be empty',
      name: 'registerFormEmailOnEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get registerFormEmailHint {
    return Intl.message(
      'Email',
      name: 'registerFormEmailHint',
      desc: '',
      args: [],
    );
  }

  /// `Password can not be empty`
  String get registerFormPasswordOnEmpty {
    return Intl.message(
      'Password can not be empty',
      name: 'registerFormPasswordOnEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get registerFormPasswordHint {
    return Intl.message(
      'Password',
      name: 'registerFormPasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get registerFormPasswordHintConfirm {
    return Intl.message(
      'Confirm password',
      name: 'registerFormPasswordHintConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Ready`
  String get registerFormButtonReady {
    return Intl.message(
      'Ready',
      name: 'registerFormButtonReady',
      desc: '',
      args: [],
    );
  }

  /// `Graphs`
  String get mainscreenButtonConsumption {
    return Intl.message(
      'Graphs',
      name: 'mainscreenButtonConsumption',
      desc: '',
      args: [],
    );
  }

  /// `Board`
  String get mainscreenButtonBoard {
    return Intl.message(
      'Board',
      name: 'mainscreenButtonBoard',
      desc: '',
      args: [],
    );
  }

  /// `Own`
  String get mainscreenConsumptionCloudIndicatorsOwn {
    return Intl.message(
      'Own',
      name: 'mainscreenConsumptionCloudIndicatorsOwn',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get mainscreenTitle {
    return Intl.message(
      'Home',
      name: 'mainscreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get drawerHome {
    return Intl.message(
      'Home',
      name: 'drawerHome',
      desc: '',
      args: [],
    );
  }

  /// `Graphs`
  String get drawerConsumption {
    return Intl.message(
      'Graphs',
      name: 'drawerConsumption',
      desc: '',
      args: [],
    );
  }

  /// `Board`
  String get drawerBoard {
    return Intl.message(
      'Board',
      name: 'drawerBoard',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get drawerNotifications {
    return Intl.message(
      'Notifications',
      name: 'drawerNotifications',
      desc: '',
      args: [],
    );
  }

  /// `My information`
  String get drawerUserInfo {
    return Intl.message(
      'My information',
      name: 'drawerUserInfo',
      desc: '',
      args: [],
    );
  }

  /// `Kuluma`
  String get drawerCommonInfo {
    return Intl.message(
      'Kuluma',
      name: 'drawerCommonInfo',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get drawerSettings {
    return Intl.message(
      'Settings',
      name: 'drawerSettings',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get drawerLogout {
    return Intl.message(
      'Logout',
      name: 'drawerLogout',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `No notifications to be shown`
  String get notificationsEmpty {
    return Intl.message(
      'No notifications to be shown',
      name: 'notificationsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Water`
  String get consumptionTopControlsWater {
    return Intl.message(
      'Water',
      name: 'consumptionTopControlsWater',
      desc: '',
      args: [],
    );
  }

  /// `Energy`
  String get consumptionTopControlsEnergy {
    return Intl.message(
      'Energy',
      name: 'consumptionTopControlsEnergy',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get consumptionListItemsDay {
    return Intl.message(
      'Day',
      name: 'consumptionListItemsDay',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get consumptionListItemsWeek {
    return Intl.message(
      'Week',
      name: 'consumptionListItemsWeek',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get consumptionListItemsMonth {
    return Intl.message(
      'Month',
      name: 'consumptionListItemsMonth',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get consumptionListItemsYear {
    return Intl.message(
      'Year',
      name: 'consumptionListItemsYear',
      desc: '',
      args: [],
    );
  }

  /// `Mo.`
  String get consumptionListItemsMonday {
    return Intl.message(
      'Mo.',
      name: 'consumptionListItemsMonday',
      desc: '',
      args: [],
    );
  }

  /// `Tu.`
  String get consumptionListItemsTuesday {
    return Intl.message(
      'Tu.',
      name: 'consumptionListItemsTuesday',
      desc: '',
      args: [],
    );
  }

  /// `We.`
  String get consumptionListItemsWednesday {
    return Intl.message(
      'We.',
      name: 'consumptionListItemsWednesday',
      desc: '',
      args: [],
    );
  }

  /// `Th.`
  String get consumptionListItemsThursday {
    return Intl.message(
      'Th.',
      name: 'consumptionListItemsThursday',
      desc: '',
      args: [],
    );
  }

  /// `Fr.`
  String get consumptionListItemsFriday {
    return Intl.message(
      'Fr.',
      name: 'consumptionListItemsFriday',
      desc: '',
      args: [],
    );
  }

  /// `Sa.`
  String get consumptionListItemsSaturday {
    return Intl.message(
      'Sa.',
      name: 'consumptionListItemsSaturday',
      desc: '',
      args: [],
    );
  }

  /// `Su.`
  String get consumptionListItemsSunday {
    return Intl.message(
      'Su.',
      name: 'consumptionListItemsSunday',
      desc: '',
      args: [],
    );
  }

  /// `L/hour`
  String get consumptionWaterLitresPerHour {
    return Intl.message(
      'L/hour',
      name: 'consumptionWaterLitresPerHour',
      desc: '',
      args: [],
    );
  }

  /// `L/day`
  String get consumptionWaterLitresPerDay {
    return Intl.message(
      'L/day',
      name: 'consumptionWaterLitresPerDay',
      desc: '',
      args: [],
    );
  }

  /// `L/month`
  String get consumptionWaterLitresPerMonth {
    return Intl.message(
      'L/month',
      name: 'consumptionWaterLitresPerMonth',
      desc: '',
      args: [],
    );
  }

  /// `Wh/hour`
  String get consumptionEnergyWatsPerHour {
    return Intl.message(
      'Wh/hour',
      name: 'consumptionEnergyWatsPerHour',
      desc: '',
      args: [],
    );
  }

  /// `Wh/day`
  String get consumptionEnergyWatsPerDay {
    return Intl.message(
      'Wh/day',
      name: 'consumptionEnergyWatsPerDay',
      desc: '',
      args: [],
    );
  }

  /// `kWh/month`
  String get consumptionEnergyKiloWatsPerMonth {
    return Intl.message(
      'kWh/month',
      name: 'consumptionEnergyKiloWatsPerMonth',
      desc: '',
      args: [],
    );
  }

  /// `Jan.`
  String get monthsShortenedJanuary {
    return Intl.message(
      'Jan.',
      name: 'monthsShortenedJanuary',
      desc: '',
      args: [],
    );
  }

  /// `Feb.`
  String get monthsShortenedFebruary {
    return Intl.message(
      'Feb.',
      name: 'monthsShortenedFebruary',
      desc: '',
      args: [],
    );
  }

  /// `Mar.`
  String get monthsShortenedMarch {
    return Intl.message(
      'Mar.',
      name: 'monthsShortenedMarch',
      desc: '',
      args: [],
    );
  }

  /// `Apr.`
  String get monthsShortenedApril {
    return Intl.message(
      'Apr.',
      name: 'monthsShortenedApril',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get monthsShortenedMay {
    return Intl.message(
      'May',
      name: 'monthsShortenedMay',
      desc: '',
      args: [],
    );
  }

  /// `Jun.`
  String get monthsShortenedJune {
    return Intl.message(
      'Jun.',
      name: 'monthsShortenedJune',
      desc: '',
      args: [],
    );
  }

  /// `Jul.`
  String get monthsShortenedJuly {
    return Intl.message(
      'Jul.',
      name: 'monthsShortenedJuly',
      desc: '',
      args: [],
    );
  }

  /// `Aug.`
  String get monthsShortenedAugust {
    return Intl.message(
      'Aug.',
      name: 'monthsShortenedAugust',
      desc: '',
      args: [],
    );
  }

  /// `Sep.`
  String get monthsShortenedSeptember {
    return Intl.message(
      'Sep.',
      name: 'monthsShortenedSeptember',
      desc: '',
      args: [],
    );
  }

  /// `Oct.`
  String get monthsShortenedOctober {
    return Intl.message(
      'Oct.',
      name: 'monthsShortenedOctober',
      desc: '',
      args: [],
    );
  }

  /// `Nov.`
  String get monthsShortenedNovember {
    return Intl.message(
      'Nov.',
      name: 'monthsShortenedNovember',
      desc: '',
      args: [],
    );
  }

  /// `Dec.`
  String get monthsShortenedDecember {
    return Intl.message(
      'Dec.',
      name: 'monthsShortenedDecember',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get monthsFullJanuary {
    return Intl.message(
      'January',
      name: 'monthsFullJanuary',
      desc: '',
      args: [],
    );
  }

  /// `February`
  String get monthsFullFebruary {
    return Intl.message(
      'February',
      name: 'monthsFullFebruary',
      desc: '',
      args: [],
    );
  }

  /// `March`
  String get monthsFullMarch {
    return Intl.message(
      'March',
      name: 'monthsFullMarch',
      desc: '',
      args: [],
    );
  }

  /// `April`
  String get monthsFullApril {
    return Intl.message(
      'April',
      name: 'monthsFullApril',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get monthsFullMay {
    return Intl.message(
      'May',
      name: 'monthsFullMay',
      desc: '',
      args: [],
    );
  }

  /// `June`
  String get monthsFullJune {
    return Intl.message(
      'June',
      name: 'monthsFullJune',
      desc: '',
      args: [],
    );
  }

  /// `July`
  String get monthsFullJuly {
    return Intl.message(
      'July',
      name: 'monthsFullJuly',
      desc: '',
      args: [],
    );
  }

  /// `August`
  String get monthsFullAugust {
    return Intl.message(
      'August',
      name: 'monthsFullAugust',
      desc: '',
      args: [],
    );
  }

  /// `September`
  String get monthsFullSeptember {
    return Intl.message(
      'September',
      name: 'monthsFullSeptember',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get monthsFullOctober {
    return Intl.message(
      'October',
      name: 'monthsFullOctober',
      desc: '',
      args: [],
    );
  }

  /// `November`
  String get monthsFullNovember {
    return Intl.message(
      'November',
      name: 'monthsFullNovember',
      desc: '',
      args: [],
    );
  }

  /// `December`
  String get monthsFullDecember {
    return Intl.message(
      'December',
      name: 'monthsFullDecember',
      desc: '',
      args: [],
    );
  }

  /// `Kelo's average consumption`
  String get consumptionAverage {
    return Intl.message(
      'Kelo\'s average consumption',
      name: 'consumptionAverage',
      desc: '',
      args: [],
    );
  }

  /// `Graphs`
  String get consumptionScreenTitle {
    return Intl.message(
      'Graphs',
      name: 'consumptionScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Someone commented on your message`
  String get notificationsSomeoneCommented {
    return Intl.message(
      'Someone commented on your message',
      name: 'notificationsSomeoneCommented',
      desc: '',
      args: [],
    );
  }

  /// `comments to your message`
  String get notificationsCommentsCount {
    return Intl.message(
      'comments to your message',
      name: 'notificationsCommentsCount',
      desc: '',
      args: [],
    );
  }

  /// `Someone liked your comment`
  String get notificationsCommentLiked {
    return Intl.message(
      'Someone liked your comment',
      name: 'notificationsCommentLiked',
      desc: '',
      args: [],
    );
  }

  /// `likes on your message`
  String get notificationsLikedCount {
    return Intl.message(
      'likes on your message',
      name: 'notificationsLikedCount',
      desc: '',
      args: [],
    );
  }

  /// `Your message was reported as inappropriate`
  String get notificationsMessageReported {
    return Intl.message(
      'Your message was reported as inappropriate',
      name: 'notificationsMessageReported',
      desc: '',
      args: [],
    );
  }

  /// `Your account has been freezed due to unacceptable behavior`
  String get notificationsAccountFreezed {
    return Intl.message(
      'Your account has been freezed due to unacceptable behavior',
      name: 'notificationsAccountFreezed',
      desc: '',
      args: [],
    );
  }

  /// `Delete message`
  String get boardConfirmDeleteMessageTitle {
    return Intl.message(
      'Delete message',
      name: 'boardConfirmDeleteMessageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this message?`
  String get boardConfirmDeleteMessageContent {
    return Intl.message(
      'Are you sure you want to delete this message?',
      name: 'boardConfirmDeleteMessageContent',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get boardConfirmDeleteMessageAccept {
    return Intl.message(
      'Delete',
      name: 'boardConfirmDeleteMessageAccept',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get boardConfirmDeleteMessageCancel {
    return Intl.message(
      'Cancel',
      name: 'boardConfirmDeleteMessageCancel',
      desc: '',
      args: [],
    );
  }

  /// `Action Log`
  String get drawerActionLog {
    return Intl.message(
      'Action Log',
      name: 'drawerActionLog',
      desc: '',
      args: [],
    );
  }

  /// `Password forgotten?`
  String get passwordForgotten {
    return Intl.message(
      'Password forgotten?',
      name: 'passwordForgotten',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fi', countryCode: 'FI'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
