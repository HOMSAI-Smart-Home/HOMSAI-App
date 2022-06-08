class GenericException implements Exception {
  final dynamic _msg;

  GenericException([this._msg]);

  @override
  String toString() => _msg?.toString() ?? super.toString();
}