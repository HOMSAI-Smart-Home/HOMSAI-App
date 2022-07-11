// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption_optimizations_forecast_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConsumptionOptimizationsForecastBodyDto
    _$ConsumptionOptimizationsForecastBodyDtoFromJson(
            Map<String, dynamic> json) =>
        ConsumptionOptimizationsForecastBodyDto(
          (json['general_power_meter_data'] as List<dynamic>)
              .map((e) => HistoryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
          (json['pv_production_meter_data'] as List<dynamic>)
              .map((e) => HistoryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
          batteryMeterData: (json['battery_meter_data'] as List<dynamic>?)
              ?.map((e) => HistoryDto.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$ConsumptionOptimizationsForecastBodyDtoToJson(
        ConsumptionOptimizationsForecastBodyDto instance) =>
    <String, dynamic>{
      'general_power_meter_data': instance.generalPowerMeterHistoricalData
          .map((e) => e.toJson())
          .toList(),
      'pv_production_meter_data': instance.pvProductionPowerMeterHistoricalData
          .map((e) => e.toJson())
          .toList(),
      'battery_meter_data':
          instance.batteryMeterData?.map((e) => e.toJson()).toList(),
    };
