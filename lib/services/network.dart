import 'package:Kuluma/tools/exceptions.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class NetworkHelper {
  /// GET request to [url] and return response as JSON data
  ///
  /// Optional bearer authentication parameter [authToken]
  static Future<Map<String, dynamic>> getJson(String url, {authToken}) async {
    var headers = <String, String>{};
    addAuthHeader(headers, authToken);

    try {
      http.Response response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      //print(response.headers.toString());
      if (response.statusCode < 300) {
        String data = response.body;

        return jsonDecode(data);
      } else {
        throw handleError(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request to [url]
  ///
  /// Optional bearer authentication parameter [authToken]
  static Future delete(String url, {authToken}) async {
    var headers = <String, String>{};
    addAuthHeader(headers, authToken);

    try {
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode < 300) {
        return response.body.isEmpty ? 'OK' : jsonDecode(response.body);
      } else {
        throw handleError(response);
      }
    } catch (e) {
      throw e;
    }
  }

  /// POST request to [url] with [jsonData] as Map
  ///
  /// Optional bearer authentication parameter [authToken]
  static Future postJson(url, jsonData, {authToken}) async {
    var headers = <String, String>{};
    addJsonHeader(
      headers,
    );
    addAuthHeader(
      headers,
      authToken,
    );

    var jsonString = jsonEncode(jsonData);

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonString,
      );

      if (response.statusCode < 300) {
        return response.body.isEmpty ? 'OK' : jsonDecode(response.body);
      } else {
        throw handleError(response);
      }
    } catch (e) {
      throw e;
    }
  }

  /// PATCH request to [url] with [jsonData] as Map
  ///
  /// Optional bearer authentication parameter [authToken]
  static Future patchJson(url, jsonData, {authToken}) async {
    var headers = <String, String>{};
    addJsonHeader(
      headers,
    );
    addAuthHeader(
      headers,
      authToken,
    );
    var jsonString = jsonEncode(jsonData);
    try {
      http.Response response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonString,
      );

      if (response.statusCode < 300) {
        return response.body.isEmpty ? 'OK' : jsonDecode(response.body);
      } else {
        throw handleError(response);
      }
    } catch (e) {
      throw e;
    }
  }

  /// PUT request to [url] with [jsonData] as Map
  ///
  /// Optional bearer authentication parameter [authToken]
  static Future putJson(url, jsonData, {authToken}) async {
    var headers = <String, String>{};
    addJsonHeader(
      headers,
    );
    addAuthHeader(
      headers,
      authToken,
    );
    var jsonString = jsonEncode(jsonData);
    try {
      http.Response response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonString,
      );

      if (response.statusCode < 300) {
        return response.body.isEmpty ? 'OK' : jsonDecode(response.body);
      } else {
        throw handleError(response);
      }
    } catch (e) {
      throw e;
    }
  }

  /// Adds JSON Content-type headers to [headers] Map
  static addJsonHeader(Map headers) {
    headers.addAll(
        <String, String>{'Content-Type': 'application/json; charset=UTF-8'});
  }

  /// If [authToken] is not null, adds bearer authorization to [headers] Map
  static addAuthHeader(Map headers, authToken) {
    if (authToken != null) {
      headers.addAll(<String, String>{'Authorization': 'Bearer $authToken'});
    }
  }

  static Exception handleError(http.Response response) {
    if (response.body != null || response.body.isNotEmpty) {
      var json = jsonDecode(response.body);
      if (json['error'] != null) {
        Log.error(json);
        if (json['error'] == 'Unauthorized')
          return Unauthorized('Unauthorized');
        return Exception([response.statusCode, json['error']]);
      }
      return Exception([response.statusCode, json]);
    }
    return Exception(response.statusCode);
  }
}
