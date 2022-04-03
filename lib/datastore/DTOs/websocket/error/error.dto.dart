import 'package:json_annotation/json_annotation.dart';

part 'error.dto.g.dart';

@JsonSerializable()
class ErrorDto {
  String code;
  String message;

  ErrorDto(this.code, this.message);

  factory ErrorDto.fromJson(Map<String, dynamic> json) =>
      _$ErrorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorDtoToJson(this);
}
