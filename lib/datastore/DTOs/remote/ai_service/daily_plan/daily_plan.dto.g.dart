// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyPlanDto _$DailyPlanDtoFromJson(Map<String, dynamic> json) => DailyPlanDto(
      (json as List<dynamic>)
          .map((e) => HourDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DailyPlanDtoToJson(DailyPlanDto instance) =>
    <String, dynamic>{
      'dailyPlan': instance.dailyPlan.map((e) => e.toJson()).toList(),
    };

HourDto _$HourDtoFromJson(Map<String, dynamic> json) => HourDto(
      json['hour'] as String?,
      (json['device_id'] as List<dynamic>)
          .map((e) => DeviceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HourDtoToJson(HourDto instance) => <String, dynamic>{
      'hour': instance.hour,
      'device_id': instance.deviceId.map((e) => e.toJson()).toList(),
    };

DeviceDto _$DeviceDtoFromJson(Map<String, dynamic> json) => DeviceDto(
      json['order'] as int?,
      json['entity_id'] as String?,
    );

Map<String, dynamic> _$DeviceDtoToJson(DeviceDto instance) => <String, dynamic>{
      'order': instance.order,
      'entity_id': instance.entityId,
    };
