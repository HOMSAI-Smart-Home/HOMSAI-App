import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/log.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_plan_body.dto.g.dart';

@JsonSerializable()
class DailyPlanBodyDto {
  List<LogDto> dailyLog = [];

  DailyPlanBodyDto(this.dailyLog);

  factory DailyPlanBodyDto.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DailyPlanBodyDtoToJson(this);

  DailyPlanBodyDto.fromList(List jsonList) {
    for (var element in jsonList) {
      dailyLog.add(LogDto.fromJson(element));
    }
  }
}
