class UrlException implements Exception {
  final dynamic _msg;

  UrlException([this._msg = 'Invalid Url']);

  @override
  String toString() => _msg.toString();
}
