import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/log.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'logbook.dto.g.dart';

@JsonSerializable()
class LogbookDto {
  @JsonKey(name: 'data')
  List<LogDto> data = [];

  LogbookDto(this.data);

  factory LogbookDto.fromJson(Map<String, dynamic> json) =>
      _$LogbookDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogbookDtoToJson(this);

  LogbookDto.fromList(List jsonList) {
    for (var element in jsonList) {
      data.add(LogDto.fromJson(element));
    }
  }
}