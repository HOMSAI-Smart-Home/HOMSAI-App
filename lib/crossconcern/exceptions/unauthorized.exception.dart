class UnauthorizedException implements Exception {
  final dynamic _msg;

  UnauthorizedException([this._msg="Unauthorized Access"]);

  @override
  String toString() => _msg.toString();
}