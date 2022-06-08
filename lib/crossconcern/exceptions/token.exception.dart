class TokenException implements Exception {
  final dynamic _msg;

  TokenException([this._msg="Token error"]);

  @override
  String toString() => _msg.toString();}