class ErrorDto {
  String? code;
  String? message;

  ErrorDto(this.code, this.message);

  ErrorDto.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message
    };
  }
}
