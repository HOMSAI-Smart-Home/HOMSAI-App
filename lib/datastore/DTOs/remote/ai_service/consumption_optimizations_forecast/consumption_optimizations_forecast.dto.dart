import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consumption_optimizations_forecast.dto.g.dart';

@JsonSerializable()
class ConsumptionOptimizationsForecastDto {
  @JsonKey(name: "general_power_meter_data")
  List<HistoryDto> generalPowerMeterHistoricalData;

  @JsonKey(name: "pv_production_meter_data")
  List<HistoryDto> pvProductionPowerMeterHistoricalData;

  ConsumptionOptimizationsForecastDto(
    this.generalPowerMeterHistoricalData,
    this.pvProductionPowerMeterHistoricalData,
  );

  factory ConsumptionOptimizationsForecastDto.fromJson(
          Map<String, dynamic> json) =>
      _$ConsumptionOptimizationsForecastDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConsumptionOptimizationsForecastDtoToJson(this);
}
