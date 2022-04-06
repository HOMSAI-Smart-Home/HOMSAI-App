class ErrorParser {
  static void parseError(dynamic error) {
    if (error != null && error['message'] != null && error['errors'] != null) {
      String errorString = error['message'] + '\n\n';
      error['errors'].forEach((_, value) {
        errorString += value.toString().replaceAll('[', '').replaceAll(']', '') + '.\n\n';
      });
      throw Exception(errorString.substring(0, errorString.length - 2));
    } else if (error != null && error['message'] != null) {
      throw Exception(error['message']);
    } else {
      throw Exception();
    }
    /*
    switch (errorCode) {
      case ErrorsProperties.API_ERROR_MISSING_PASSWORD :
        throw MissingArgumentsException();
      case ErrorsProperties.API_ERROR_USER_NOT_FOUND:
        throw UserNotFoundException();
      default:
        throw GenericException();
    }
    */
  }
}
