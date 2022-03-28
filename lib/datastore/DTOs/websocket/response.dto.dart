import 'package:homsai/datastore/DTOs/websocket/error.dto.dart';

class ResponseDto {
  int? id;
  String? type;
  bool? success;
  dynamic result;
  ErrorDto? error;

  ResponseDto(this.id, this.type, this.success, this.result);

  ResponseDto.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    type = json["type"];
    success = json["success"];

    if (success!) {
      result = json["result"];
    } else {
      error = ErrorDto.fromJson(json["error"]);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'success': success,
      'result': result,
      'error': error,
    };
  }
}
