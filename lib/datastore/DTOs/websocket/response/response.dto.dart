import 'package:homsai/datastore/DTOs/websocket/error/error.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.dto.g.dart';

@JsonSerializable()
class ResponseDto {
  int id;
  String type;
  bool? success;
  dynamic result;
  ErrorDto? error;
  Map<String, dynamic>? event;

  ResponseDto(this.id, this.type, this.success, this.result);

  factory ResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDtoToJson(this);
}
