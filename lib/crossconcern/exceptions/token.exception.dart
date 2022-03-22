class InvalidRequest implements Exception {
  String message = "Empty request";

  InvalidRequest(String s) {
    message = s;
  }

  String errMsg() => message;
}