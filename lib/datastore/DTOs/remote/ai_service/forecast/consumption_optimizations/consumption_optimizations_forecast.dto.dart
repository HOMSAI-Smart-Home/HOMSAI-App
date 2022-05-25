import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consumption_optimizations_forecast.dto.g.dart';

@JsonSerializable()
class ConsumptionOptimizationsForecastDto {
  @JsonKey(name: "optimized_general_power_meter_data")
  List<HistoryDto> optimizedGeneralPowerMeterData;
  @JsonKey(name: "optimized_battery_data")
  List<HistoryDto>? optimizedBatteryData;
  @JsonKey(name: "without_homsai")
  PVBalanceDto withoutHomsai;
  @JsonKey(name: "with_homsai")
  PVBalanceDto withHomsai;

  ConsumptionOptimizationsForecastDto(
    this.optimizedGeneralPowerMeterData,
    this.withoutHomsai,
    this.withHomsai, {
    this.optimizedBatteryData,
  });

  factory ConsumptionOptimizationsForecastDto.fromJson(
          Map<String, dynamic> json) =>
      _$ConsumptionOptimizationsForecastDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConsumptionOptimizationsForecastDtoToJson(this);
}

@JsonSerializable()
class PVBalanceDto {
  @JsonKey(name: "bought_energy")
  double boughtEnergy;
  @JsonKey(name: "bought_energy_expense")
  double boughtEnergyExpense;
  @JsonKey(name: "sold_energy")
  double soldEnergy;
  @JsonKey(name: "sold_energy_earning")
  double soldEnergyEarning;
  @JsonKey(name: "self_consumption_percent")
  double selfConsumptionPercent;
  double balance;

  PVBalanceDto(
    this.boughtEnergy,
    this.boughtEnergyExpense,
    this.soldEnergy,
    this.soldEnergyEarning,
    this.selfConsumptionPercent,
    this.balance,
  );

  factory PVBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$PVBalanceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PVBalanceDtoToJson(this);
}
