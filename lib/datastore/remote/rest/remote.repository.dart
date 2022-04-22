import 'dart:convert';
import 'dart:io';

import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';
import 'package:http/http.dart';

class RemoteRepository implements RemoteInterface {
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  Client client = Client();
  static const Duration _timeout = Duration(seconds: 10);

  Map<String, dynamic> parseResponse(Response response) {
    dynamic body;
    dynamic bodyList;

    try {
      body = json.decode(response.body);
    } on FormatException {
      body = {'data': response.body};
    }

    bodyList = body;
    if (bodyList is List) {
      body = {'data': bodyList};
    }

    return body;
  }

  @override
  Future<Map<String, dynamic>> get(
    Uri url, {
    Map<String, String>? headers,
    Duration timeout = _timeout,
  }) async {
    final Response response = await client
        .get(
          url,
          headers: headers,
        )
        .timeout(timeout);
    return parseResponse(response);
  }

  @override
  Future<Map<String, dynamic>> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout = const Duration(seconds: 120),
  }) async {
    final Response response = await client
        .post(
          url,
          headers: headers,
          body: (headers?[HttpHeaders.contentTypeHeader] == 'application/json')
              ? jsonEncode(body)
              : body,
          encoding: encoding,
        )
        .timeout(timeout);
    final h = jsonEncode(body);
    print(h);
    return parseResponse(response);
  }

  @override
  Future<Map<String, dynamic>> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout = _timeout,
  }) async {
    final Response response = await client
        .put(
          url,
          headers: headers,
          body: (headers?[HttpHeaders.contentTypeHeader] == 'application/json')
              ? jsonEncode(body)
              : body,
        )
        .timeout(timeout);
    return parseResponse(response);
  }

  @override
  Future<Map<String, dynamic>> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout = _timeout,
  }) async {
    final Response response = await client
        .delete(
          url,
          headers: headers,
        )
        .timeout(timeout);
    return parseResponse(response);
  }
}
