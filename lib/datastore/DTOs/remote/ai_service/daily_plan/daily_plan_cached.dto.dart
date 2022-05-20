import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:json_annotation/json_annotation.dart';
part 'daily_plan_cached.dto.g.dart';

@JsonSerializable()
class DailyPlanCachedDto {
  @JsonKey(name: 'daily_plan')
  DailyPlanDto dailyPlan;

  @JsonKey(name: 'data_fetched')
  DateTime dateFetched;

  DailyPlanCachedDto(this.dailyPlan, this.dateFetched);

  factory DailyPlanCachedDto.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanCachedDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DailyPlanCachedDtoToJson(this);
}
