import 'package:Kuluma/tools/common.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import '../models/account.dart';
import '../tools/logging.dart';
import '../tools/utils.dart';
import '../services/network.dart';
import '../config.dart';
import '../models/consumption_collection.dart';
import '../models/user.dart';

class User with ChangeNotifier {
  late Function _notification;
  late Function _clearNotificationProvider;
  late bool _authStatus = false;
  late bool _authLoading = false;
  bool _tokenIsRefressing = false;
  late bool _intro;
  late Box<dynamic> _db;
  UserModel? _userData;
  Account? _accountData;
  ConsumptionCollection? consumptionCloudData;

  String get petState {
    return consumptionCloudData?.petState ?? 'NEUTRAL';
  }

  User(Box<dynamic> db) {
    _db = db;
    _userData = _db.containsKey(0) ? _db.get(0) : null;

    _authLoading = true;
    notifyListeners();
    _autoLogin();
  }

  // notification_provider dependency injection
  void update(activateSnackBar, clear) {
    _notification = activateSnackBar;
    _clearNotificationProvider = clear;
  }

  /// Requires [String endpoint]. Endpoint is attached to base url, example: http://example.fi/api/endpoint.
  /// optional parameters:
  /// [bool authenticationRequired], true by default
  /// [Map data], empty by default
  Future<dynamic> apiPost({
    required String endpoint,
    bool authenticationRequired = true,
    Map data = const {},
  }) async {
    try {
      if (authenticationRequired && _isAuthTokenExpired()) {
        await _updateToken();
      }
      Log.success("POST", endpoint, data);
      return authenticationRequired
          ? NetworkHelper.postJson(
              AppConfig.getUrl(endpoint),
              data,
              authToken: _userData?.accessToken,
            ).timeout(const Duration(seconds: 10))
          : NetworkHelper.postJson(
              AppConfig.getUrl(endpoint),
              data,
            ).timeout(const Duration(seconds: 10));
    } catch (e) {
      Log.error("Error with Post request in user_provider", e);
      rethrow;
    }
  }

  /// Requires [String endpoint]. Endpoint is attached to base url, example: http://example.fi/api/endpoint.
  /// optional parameters:
  /// [bool authenticationRequired], true by default
  /// [Map data], empty by default
  Future<dynamic> apiPatch({
    required String endpoint,
    bool authenticationRequired = true,
    Map data = const {},
  }) async {
    Log.success("PATCH", endpoint, data);

    try {
      if (authenticationRequired && _isAuthTokenExpired()) await _updateToken();
      return authenticationRequired
          ? NetworkHelper.patchJson(
              AppConfig.getUrl(endpoint),
              data,
              authToken: _userData?.accessToken,
            )
          : NetworkHelper.patchJson(
              AppConfig.getUrl(endpoint),
              data,
            );
    } catch (e) {
      Log.error("Error in apiPatch", e);
      rethrow;
    }
  }

  /// Requires [String endpoint]. Endpoint is attached to base url, example: http://example.fi/api/endpoint.
  /// optional parameters:
  /// [bool authenticationRequired], true by default
  /// [Map data], empty by default
  Future<dynamic> apiPut({
    required String endpoint,
    bool authenticationRequired = true,
    Map data = const {},
  }) async {
    Log.success("PUT", endpoint, data);

    try {
      if (authenticationRequired && _isAuthTokenExpired()) await _updateToken();
      return authenticationRequired
          ? NetworkHelper.putJson(
              AppConfig.getUrl(endpoint),
              data,
              authToken: _userData?.accessToken,
            )
          : NetworkHelper.putJson(
              AppConfig.getUrl(endpoint),
              data,
            );
    } catch (e) {
      Log.error("Error in apiPut", e);
      rethrow;
    }
  }

  /// Requires [String endpoint]. Endpoint is attached to base url, example: http://example.fi/api/endpoint.
  /// optional parameters:
  /// [bool authenticationRequired], true by default
  /// [Map data], empty by default
  Future<Map<String, dynamic>> apiGet({
    required String endpoint,
    bool authenticationRequired = true,
    Map data = const {},
  }) async {
    Log.info("GET: ", endpoint);
    try {
      if (authenticationRequired && _isAuthTokenExpired()) await _updateToken();

      return authenticationRequired
          ? NetworkHelper.getJson(
              AppConfig.getUrl(endpoint),
              authToken: _userData?.accessToken,
            )
          : NetworkHelper.getJson(
              AppConfig.getUrl(endpoint),
            );
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }

  /// Requires [String endpoint]. Endpoint is attached to base url, example: http://example.fi/api/endpoint.
  /// optional parameters:
  /// [bool authenticationRequired], true by default
  /// [Map data], empty by default
  Future<dynamic> apiDelete({
    required String endpoint,
    bool authenticationRequired = true,
    Map data = const {},
  }) async {
    Log.success("DELETE: ", endpoint);
    try {
      if (authenticationRequired && _isAuthTokenExpired()) await _updateToken();

      return authenticationRequired
          ? NetworkHelper.delete(
              AppConfig.getUrl(endpoint),
              authToken: _userData?.accessToken,
            )
          : NetworkHelper.delete(
              AppConfig.getUrl(endpoint),
            );
    } catch (e) {
      Log.error("DELETE: ", e);
      rethrow;
    }
  }

  Future<void> authenticate(String username, String password) async {
    Map logindata = {'username': username, 'password': password};
    try {
      final response = await this.apiPost(
        endpoint: 'login',
        data: logindata,
        authenticationRequired: false,
      );

      await _setUserData(response);
      await fetchAccount();
    } catch (e) {
      Log.info(
        e,
      );

      _notification(
          errorMessage: e.toString() == 'Exception: 500'
              ? 'Tarkista käyttäjätunnus ja salasana'
              : 'Virhe kirjautumisessa');
      rethrow;
    }
  }

  Future<void> fetchAccount() async {
    try {
      final account = await this.apiGet(endpoint: 'account');
      Log.success(account);
      _accountData = Account.fromJson(account['account']);
      _userData?.pet = _accountData?.selectedPet ?? 0;
      _userData?.petName = _accountData?.petName ?? '(no name, error?)';

      Log.success(_accountData?.petName);

      _saveUserDataToHive();
      notifyListeners();
    } catch (e) {
      Log.error('Error fetching account', e);
    }
  }

  Account? get accountDataSync {
    if (_accountData == null)
      throw Exception("Account data is not present in the provider");
    return _accountData;
  }

  Future<void> _autoLogin() async {
    try {
      if (_userData == null) throw Exception("No _userData");

      await _updateToken();
      Log.success("Autologin successful for user:", _userData?.userName,
          DateTime.now());
      notifyListeners();
      await fetchAccount();
    } catch (e) {
      Log.info("Autologin aborted due the following reason:", e);
    } finally {
      _authLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    NetworkHelper.postJson(
      AppConfig.getUrl("auth/token/revoke/refresh"),
      null,
      authToken: _userData?.refreshToken,
    )
        .then((value) => Log.success("revoked refresh token successfully"))
        .catchError((err) => Log.error(err));

    _db.delete(0);
    // _db.delete(Utils.hiveBoardIdForUser(id)); // BoardItems
    _authStatus = false;
    _userData = null;
    _accountData = null;
    consumptionCloudData = null;
    _clearNotificationProvider();
    Log.success("User is logged out successfully");
    notifyListeners();
  }

  Future<String?> checkRegistrationCode(code) async {
    try {
      var res = await this.apiPatch(
        endpoint: 'register',
        data: {"code": code},
        authenticationRequired: false,
      );

      if (res['active_lease']['_id'] == null) return null;

      Log.success("Registration code verified");
      return res['active_lease']['_id'];
    } catch (e) {
      Log.warn("Registration code check failed", e);
      _notification(errorMessage: "Tarkista koodi!");
      return null;
    }
  }

  Future<void> registerNewUser({
    required Map registrationData,
  }) async {
    try {
      final response = await this.apiPost(
        endpoint: 'register',
        data: registrationData,
        authenticationRequired: false,
      );

      Log.warn("response from registering new user", response);
      await _setUserData(response);
      await fetchAccount();
      /* _notification(
        errorMessage: 'Lemmikki päivitetty!',
      ); */
    } catch (e) {
      Log.error("RegisterNewUser", e);
      _notification(errorMessage: "Rekisteröitymisessä tapahtui virhe.");
      rethrow;
    }
  }

  Future<void> _updateToken() async {
    try {
      if (_tokenIsRefressing) return;

      _tokenIsRefressing = true;
      // Use refresh token instead of access token to get new access token
      var response = await NetworkHelper.postJson(
        AppConfig.getUrl("auth/token/refresh"),
        {},
        authToken: _userData?.refreshToken,
      );

      _userData?.accessToken = response['access_token'];
      _authStatus = true;
      _setTokenExpires();
      _tokenIsRefressing = false;
      notifyListeners();
    } catch (e) {
      _tokenIsRefressing = false;
      logout();
      Log.warn("_updateToken", e);

      rethrow;
    }
  }

  Future<void> _saveUserDataToHive() async {
    try {
      await _db.put(0, _userData);
      // await _db.delete(Utils.hiveBoardIdForUser(id));
    } catch (e) {
      Log.error(e);
      // print(e);
      rethrow;
    }
  }

  Future<void> _setUserData(Map response) async {
    try {
      Log.error("data", response);
      _userData = UserModel(
        userName: response['user']['username'],
        role: response['user']['role'],
        id: response['user']['_id'],
        apartment: response['user']['apartment'],
        accessToken: response['access_token'],
        refreshToken: response['refresh_token'],
      );
      _authStatus = true;
      _setTokenExpires();
      await _saveUserDataToHive();

      Log.success(
          "Login successful for user:", _userData?.userName, DateTime.now());
      notifyListeners();
    } catch (e) {
      Log.error(e);
      rethrow;
    }
  }

  void _setTokenExpires() {
    if (isAuth) {
      int exp = Utils.parseJwt(_userData?.accessToken)['exp'];
      Log.info("expires:", _userData?.authTokenExpires);
      _userData?.authTokenExpires = exp * 1000;
      return;
    }
    throw Exception("User is logged out.");
  }

  bool _isAuthTokenExpired() {
    _userData?.authTokenExpires ?? _setTokenExpires();

    return (_userData?.authTokenExpires ?? 10000000000000) <
        DateTime.now().millisecondsSinceEpoch;
  }

  Map<String, String> get userBasicData {
    return {
      'username': _userData?.userName ?? '...',
      'role': _userData?.role ?? '...',
      'id': _userData?.id ?? '...',
    };
  }

  void introDone() => _db.put(id.hashCode, true);

  // For debugging purposes
  void resetDataBase() async {
    int count = await _db.clear();
    Log.success("Database cleared.", "entries removed:", count);
  }

  Box<dynamic> get db {
    return _db;
  }

  Future<Account> account({bool refresh = false}) async {
    if (_accountData == null || refresh) await fetchAccount();
    return _accountData!;
  }

  DateTime get leaseStart {
    return _accountData?.activeFrom ?? DateTime(2020);
  }

  DateTime get leaseEnd {
    return _accountData?.activeTo ?? DateTime(2100);
  }

  bool get intro {
    _intro = !_db.containsKey(id.hashCode);
    return _intro;
  }

  bool get isAuth {
    return _authStatus;
  }

  String? get role {
    return _userData?.role;
  }

  bool get isAuthLoading {
    return _authLoading;
  }

  Function get notification {
    return _notification;
  }

  String? get id {
    return _userData?.id;
  }

  String get apartment {
    return _userData?.apartment ?? '';
  }

  int? get pet {
    return _userData?.pet;
  }

  String get petName {
    return _userData?.petName ?? '';
  }

  void selectPet(int val) {
    final prev = _userData?.pet;
    _userData?.pet = val;
    notifyListeners();
    _saveUserDataToHive();
    updateSelectedPet(val, prev);
  }

  Future<void> updateSelectedPet(pet, prev) async {
    try {
      final petData = {'character': pet, 'name': petName};

      await apiPatch(endpoint: 'account/pet', data: petData);
    } catch (e) {
      Log.error(e);
      _userData?.pet = prev;
      notifyListeners();
      _notification(
        errorMessage: 'Virhe yhteydessä palvelimeen',
      );
    }
  }

  Future<void> savePetName(String text, {int? selected}) async {
    try {
      if (text.isEmpty || text.length < 2) {
        _notification(
          errorMessage:
              'Lemmikin nimen täytyy olla ainakin kaksi merkkiä pitkä!',
        );
        return;
      }

      _userData?.petName = text;
      _saveUserDataToHive();
      final petData = {
        'name': text,
        'character': pet ?? selected,
      };
      await apiPatch(endpoint: 'account/pet', data: petData);
      /* _notification(
        errorMessage: 'Lemmikki päivitetty!',
      ); */
    } catch (e) {
      _notification(
        errorMessage: 'Lemmikkin päivittämisessä ilmeni ongelmia..',
      );
      Log.error("Error updating pet data", e);
    }
  }

  Future<ConsumptionCollection> fetchCloudData() async {
    try {
      if (_userData?.role == Role.admin.asString() ||
          _userData?.role == Role.maintainer.asString()) {
        consumptionCloudData = ConsumptionCollection.createDummy();
      }
      if (consumptionCloudData != null) return consumptionCloudData!;

      var res = await this.apiGet(
        endpoint: "entry/collection",
      );

      Log.success(res);

      consumptionCloudData = ConsumptionCollection.fromJson(res);

      return consumptionCloudData!;
    } catch (err) {
      Log.error("error fetching consumption cloud data", err);
      if (consumptionCloudData != null) return consumptionCloudData!;
      throw Exception(
          "Can't load consumption cloud data from the server and cache is empty");
    }
  }
}
