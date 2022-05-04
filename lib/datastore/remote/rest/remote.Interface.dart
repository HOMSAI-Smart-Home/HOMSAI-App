import 'dart:convert';

import 'package:http/http.dart';

abstract class RemoteInterface {
  Map<String, dynamic> parseResponse(Response response);
  Future<Map<String, dynamic>> get(
    Uri url, {
    Map<String, String>? headers,
    Duration timeout,
    Uri? fallbackUrl,
  });
  Future<Map<String, dynamic>> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout,
    Uri? fallbackUrl,
  });
  Future<Map<String, dynamic>> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout,
    Uri? fallbackUrl,
  });
  Future<Map<String, dynamic>> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
    Duration timeout,
    Uri? fallbackUrl,
  });
}
