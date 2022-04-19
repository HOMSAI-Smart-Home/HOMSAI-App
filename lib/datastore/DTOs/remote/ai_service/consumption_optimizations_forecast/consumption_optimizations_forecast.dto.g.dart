// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption_optimizations_forecast.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumptionOptimizationsForecastDto
    _$ConsumptionOptimizationsForecastDtoFromJson(Map<String, dynamic> json) =>
        ConsumptionOptimizationsForecastDto(
          (json['general_power_meter_data'] as List<dynamic>)
              .map((e) => HistoryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
          (json['pv_production_meter_data'] as List<dynamic>)
              .map((e) => HistoryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ConsumptionOptimizationsForecastDtoToJson(
        ConsumptionOptimizationsForecastDto instance) =>
    <String, dynamic>{
      'general_power_meter_data': instance.generalPowerMeterHistoricalData
          .map((e) => e.toJson())
          .toList(),
      'pv_production_meter_data': instance.pvProductionPowerMeterHistoricalData
          .map((e) => e.toJson())
          .toList(),
    };
