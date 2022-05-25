import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'consumption_optimizations_forecast_body.dto.g.dart';

@JsonSerializable()
class ConsumptionOptimizationsForecastBodyDto {
  @JsonKey(name: "general_power_meter_data")
  List<HistoryDto> generalPowerMeterHistoricalData;

  @JsonKey(name: "pv_production_meter_data")
  List<HistoryDto> pvProductionPowerMeterHistoricalData;

  @JsonKey(name: "battery_meter_data")
  List<HistoryDto>? batteryMeterData;

  @JsonKey(name: "general_power_meter_data_unit")
  String generalPowerMeterDataUnit;

  @JsonKey(name: "pv_production_meter_data_unit")
  String pvProductionMeterDaraUnit;

  ConsumptionOptimizationsForecastBodyDto(
    this.generalPowerMeterHistoricalData,
    this.generalPowerMeterDataUnit,
    this.pvProductionPowerMeterHistoricalData,
    this.pvProductionMeterDaraUnit, {
    this.batteryMeterData,
  });

  factory ConsumptionOptimizationsForecastBodyDto.fromJson(
          Map<String, dynamic> json) =>
      _$ConsumptionOptimizationsForecastBodyDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ConsumptionOptimizationsForecastBodyDtoToJson(this);
}
