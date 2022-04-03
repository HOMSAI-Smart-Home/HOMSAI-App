import 'package:json_annotation/json_annotation.dart';

part 'service_body.dto.g.dart';

@JsonSerializable()
class ServiceBodyDto {
  Map<String, dynamic>? serviceData;
  Map<String, dynamic>? target;

  ServiceBodyDto(this.serviceData, this.target);

  factory ServiceBodyDto.fromJson(Map<String, dynamic> json) =>
      _$ServiceBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceBodyDtoToJson(this);
}
