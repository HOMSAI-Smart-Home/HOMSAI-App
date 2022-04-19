import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast_body.dto.dart';

abstract class AIServiceInterface {
  Future<ConsumptionOptimizationsForecastDto>
      getPhotovoltaicSelfConsumptionOptimizerForecast(
    Uri url,
    ConsumptionOptimizationsForecastBodyDto optimizationsForecastBody,
    String unit,
  );

  Future<DailyPlanDto> getDailyPlan(
    Uri url,
    DailyPlanBodyDto dailyPlanBodyDto,
    int deviceNumber,
    List<String> entitysType,
  );
}
