import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/log.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logbook.dto.g.dart';

@JsonSerializable()
class LogbookDto {
  List<LogDto> logbook = [];

  LogbookDto(this.logbook);

  factory LogbookDto.fromJson(Map<String, dynamic> json) =>
      _$LogbookDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogbookDtoToJson(this);

  LogbookDto.fromList(List jsonList) {
    for (var element in jsonList) {
      logbook.add(LogDto.fromJson(element));
    }
  }
}