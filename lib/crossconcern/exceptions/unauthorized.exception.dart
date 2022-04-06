class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({this.message="Unauthorized Access"});

  String errMsg() => message;
}