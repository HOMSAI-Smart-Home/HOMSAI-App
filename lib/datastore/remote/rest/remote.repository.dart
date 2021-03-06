import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:f_logs/f_logs.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';
import 'package:http/http.dart';

class RemoteRepository implements RemoteInterface {
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  Client client = Client();
  static const Duration _timeout = Duration(seconds: 10);

  @override
  Map<String, dynamic> parseResponse(Response response) {
    dynamic body;
    dynamic bodyList;

    FLog.info(
      className: "RemoteRepository",
      methodName: "_parseResponse_response",
      text: response.body,
      dataLogType: DataLogType.NETWORK.toString(),
    );

    try {
      body = json.decode(response.body);
    } on FormatException {
      body = {'data': response.body};
    }

    bodyList = body;
    if (bodyList is List) {
      body = {'data': bodyList};
    }

    FLog.info(
      className: "RemoteRepository",
      methodName: "_parseResponse_parsed_response",
      text: body.toString(),
      dataLogType: DataLogType.NETWORK.toString(),
    );
    return body;
  }

  Future<T> _fallback<T>(
    Uri url, {
    Uri? fallbackUrl,
    required Future<T> Function(Uri) function,
  }) async {
    try {
      return await function(url);
    } catch (e) {
      if (e is TimeoutException || e is SocketException) {
        try {
          throwIf(fallbackUrl == null, e);
          return await function(fallbackUrl!);
        } catch (_) {
          rethrow;
        }
      }
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> get(
    Uri url, {
    Map<String, String>? headers,
    Duration timeout = _timeout,
    Uri? fallbackUrl,
  }) async {
    final Response response = await _fallback<Response>(
      url,
      fallbackUrl: fallbackUrl,
      function: (url) {
        FLog.info(
          className: "RemoteRepository",
          methodName: "_get",
          text: url.toString(),
          dataLogType: DataLogType.NETWORK.toString(),
        );

        return client
            .get(
              url,
              headers: headers,
            )
            .timeout(timeout);
      },
    );

    return parseResponse(response);
  }

  @override
  Future<Map<String, dynamic>> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout = const Duration(seconds: 120),
    Uri? fallbackUrl,
  }) async {
    final Response response = await _fallback<Response>(
      url,
      fallbackUrl: fallbackUrl,
      function: (url) {
        FLog.info(
          className: "RemoteRepository",
          methodName: "_post_url",
          text: url.toString(),
          dataLogType: DataLogType.NETWORK.toString(),
        );
        FLog.info(
          className: "RemoteRepository",
          methodName: "_post_body",
          text: body.toString(),
          dataLogType: DataLogType.NETWORK.toString(),
        );
        return client
            .post(
              url,
              headers: headers,
              body: (headers?[HttpHeaders.contentTypeHeader] ==
                      'application/json')
                  ? jsonEncode(body)
                  : body,
              encoding: encoding,
            )
            .timeout(timeout);
      },
    );
    return parseResponse(response);
  }

  @override
  Future<Map<String, dynamic>> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout = _timeout,
    Uri? fallbackUrl,
  }) async {
    final Response response = await _fallback<Response>(
      url,
      fallbackUrl: fallbackUrl,
      function: (url) {
        FLog.info(
          className: "RemoteRepository",
          methodName: "_put_url",
          text: url.toString(),
          dataLogType: DataLogType.NETWORK.toString(),
        );
        FLog.info(
          className: "RemoteRepository",
          methodName: "_put_body",
          text: body.toString(),
          dataLogType: DataLogType.NETWORK.toString(),
        );

        return client
            .put(
              url,
              headers: headers,
              body: (headers?[HttpHeaders.contentTypeHeader] ==
                      'application/json')
                  ? jsonEncode(body)
                  : body,
            )
            .timeout(timeout);
      },
    );
    return parseResponse(response);
  }

  @override
  Future<Map<String, dynamic>> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout = _timeout,
    Uri? fallbackUrl,
  }) async {
    final Response response = await _fallback<Response>(
      url,
      fallbackUrl: fallbackUrl,
      function: (url) {
        FLog.info(
          className: "RemoteRepository",
          methodName: "_delete",
          text: url.toString(),
          dataLogType: DataLogType.NETWORK.toString(),
        );

        return client
            .delete(
              url,
              headers: headers,
            )
            .timeout(timeout);
      },
    );
    return parseResponse(response);
  }
}
