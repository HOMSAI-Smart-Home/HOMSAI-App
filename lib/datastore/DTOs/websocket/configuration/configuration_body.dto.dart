import 'package:json_annotation/json_annotation.dart';

part 'configuration_body.dto.g.dart';

@JsonSerializable()
class ConfigurationBodyDto {
  Map<String, dynamic>? trigger;
  Map<String, dynamic>? condition;
  Map<String, dynamic>? action;

  ConfigurationBodyDto(this.trigger, this.condition, this.action);

  factory ConfigurationBodyDto.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationBodyDtoToJson(this);
}
