import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logbook_body.dto.g.dart';

@JsonSerializable()
@TimezoneDateTimeConverter()
class LogbookBodyDto {
  @JsonKey(name: 'end_time')
  DateTime? endTime;

  LogbookBodyDto({
    this.endTime,
  });

  factory LogbookBodyDto.fromJson(Map<String, dynamic> json) =>
      _$LogbookBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogbookBodyDtoToJson(this);
}
