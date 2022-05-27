import 'package:homsai/crossconcern/utilities/util/anonimizer.util.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/log.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_plan_body.dto.g.dart';

@JsonSerializable()
class DailyPlanBodyDto {
  List<LogDto> dailyLog = [];

  DailyPlanBodyDto(this.dailyLog);

  factory DailyPlanBodyDto.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanBodyDtoFromJson(json);

  DailyPlanBodyDto cipher(Anonymizer anonymizer) =>
      DailyPlanBodyDto(dailyLog.map((log) => log.cipher(anonymizer)).toList());

  Map<String, dynamic> toJson() => _$DailyPlanBodyDtoToJson(this);

  DailyPlanBodyDto.fromList(List jsonList) {
    for (var element in jsonList) {
      if (element != null && element.entityId != null) {
        dailyLog.add(element as LogDto);
      }
    }
  }
}
