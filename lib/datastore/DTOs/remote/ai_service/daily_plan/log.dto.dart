import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'log.dto.g.dart';

@JsonSerializable()
@DateTimeConverter()
class LogDto {
  String? state;
  @JsonKey(name: 'entity_id')
  String? entityId;
  String? name;
  DateTime? when;

  LogDto(
    this.state,
    this.entityId,
    this.name,
    this.when,
  );

  factory LogDto.fromJson(Map<String, dynamic> json) => _$LogDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogDtoToJson(this);
}
