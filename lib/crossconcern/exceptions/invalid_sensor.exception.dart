class InvalidSensorException implements Exception {
  final String message;

  InvalidSensorException({this.message = "Invalid sensor must not be null"});

  String errMsg() => message;
}
