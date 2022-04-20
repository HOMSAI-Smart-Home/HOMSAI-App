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
          PVBalanceDto.fromJson(json['without_homsai'] as Map<String, dynamic>),
          PVBalanceDto.fromJson(json['with_homsai'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$ConsumptionOptimizationsForecastDtoToJson(
        ConsumptionOptimizationsForecastDto instance) =>
    <String, dynamic>{
      'general_power_meter_data': instance.optimizedGeneralPowerMeterData
          .map((e) => e.toJson())
          .toList(),
      'without_homsai': instance.withoutHomsai.toJson(),
      'with_homsai': instance.withHomsai.toJson(),
    };

PVBalanceDto _$PVBalanceDtoFromJson(Map<String, dynamic> json) => PVBalanceDto(
      (json['bought_energy'] as num).toDouble(),
      (json['bought_energy_expense'] as num).toDouble(),
      (json['sold_energy'] as num).toDouble(),
      (json['sold_energy_earning'] as num).toDouble(),
      (json['self_consumption_percent'] as num).toDouble(),
      (json['balance'] as num).toDouble(),
    );

Map<String, dynamic> _$PVBalanceDtoToJson(PVBalanceDto instance) =>
    <String, dynamic>{
      'bought_energy': instance.boughtEnergy,
      'bought_energy_expense': instance.boughtEnergyExpense,
      'sold_energy': instance.soldEnergy,
      'sold_energy_earning': instance.soldEnergyEarning,
      'self_consumption_percent': instance.selfConsumptionPercent,
      'balance': instance.balance,
    };
