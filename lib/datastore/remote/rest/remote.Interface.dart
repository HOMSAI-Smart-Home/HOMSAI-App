import 'dart:convert';

abstract class RemoteInterface {
  Future<Map<String, dynamic>> get(
    Uri url,
    Map<String, String> queryParameters, {
    Map<String, String>? headers,
  });
  Future<Map<String, dynamic>> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
  Future<Map<String, dynamic>> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
  Future<Map<String, dynamic>> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  });
}
