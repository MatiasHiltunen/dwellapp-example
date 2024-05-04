import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

class Utils {
  static final random = Random();

  static Map<String, dynamic> parseJwt(String? token) {
    try {
      if (token == null) throw Exception("JWT token can't be null");

      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);
      if (payloadMap is! Map<String, dynamic>) {
        throw Exception('invalid payload');
      }
      return payloadMap;
    } catch (e) {
      rethrow;
    }
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static void dismissKeyboard(context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus?.unfocus();
    }

    /* FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    } */
  }

  static double doubleInRange(double start, double end) =>
      random.nextDouble() * (end - start) + start;

  static String queryParams(
      {required String endpoint, required Map<String, String> params}) {
    return endpoint +
        params.entries.fold('?', (previousValue, element) {
          return '$previousValue${previousValue == '?' ? '' : '&'}${element.key}=${element.value}';
        });
  }

  static int hiveBoardIdForUser(String uid) {
    // 4 is typeid in Hive for message items.
    // Adding 4 to user id hashCode integer is one way to ensure
    // that there is no conflicts with other same users Hive ids.
    return 4 + uid.hashCode;
  }
}
