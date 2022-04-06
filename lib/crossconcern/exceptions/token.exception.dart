class InvalidRequest implements Exception {
  final String message;

  InvalidRequest({this.message="Empty request"});

  String errMsg() => message;
}
