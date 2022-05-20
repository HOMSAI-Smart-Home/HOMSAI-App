// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan_cached.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyPlanCachedDto _$DailyPlanCachedDtoFromJson(Map<String, dynamic> json) =>
    DailyPlanCachedDto(
      DailyPlanDto.fromJson(json['daily_plan'] as Map<String, dynamic>),
      DateTime.parse(json['data_fetched'] as String),
    );

Map<String, dynamic> _$DailyPlanCachedDtoToJson(DailyPlanCachedDto instance) =>
    <String, dynamic>{
      'daily_plan': instance.dailyPlan.toJson(),
      'data_fetched': instance.dateFetched.toIso8601String(),
    };
