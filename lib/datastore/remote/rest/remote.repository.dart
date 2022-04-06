import 'dart:convert';
import 'dart:io';

import 'package:homsai/crossconcern/exceptions/unauthorized.exception.dart';
import 'package:homsai/crossconcern/helpers/errors/error.parser.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';
import 'package:http/http.dart';

class RemoteRepository implements RemoteInterface {
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  Client client = Client();
  static const Duration _timeout = Duration(seconds: 5);

  Map<String, String> getHeader() {
    final headers = {HttpHeaders.acceptHeader: 'application/json'};

    final HomeAssistantAuth? token = appPreferences.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer ' + token.token;
    }

    return headers;
  }

  Map<String, dynamic> parseResponse(Response response) {
    dynamic body;
    dynamic bodyList;

    try {
      body = json.decode(response.body);
    } on FormatException catch (e) {
      print(e.message);
      body = {'data': response.bodyBytes};
    }

    if (response.statusCode == HttpStatus.unauthorized) {
      throw UnauthorizedException;
    } else if (response.statusCode >= HttpStatus.badRequest) {
      ErrorParser.parseError(body);
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
          headers: headers ?? getHeader(),
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
          headers: headers ?? getHeader(),
          body: body,
          encoding: encoding,
        )
        .timeout(timeout);
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
          headers: headers ?? getHeader(),
          body: body,
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
          headers: headers ?? getHeader(),
        )
        .timeout(timeout);
    return parseResponse(response);
  }
}
