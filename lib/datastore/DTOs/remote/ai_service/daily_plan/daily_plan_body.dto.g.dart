// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyPlanBodyDto _$DailyPlanBodyDtoFromJson(Map<String, dynamic> json) =>
    DailyPlanBodyDto(
      (json['dailyLog'] as List<dynamic>)
          .map((e) => LogDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyPlanBodyDtoToJson(DailyPlanBodyDto instance) =>
    <String, dynamic>{
      'dailyLog': instance.dailyLog.map((e) => e.toJson()).toList(),
    };
