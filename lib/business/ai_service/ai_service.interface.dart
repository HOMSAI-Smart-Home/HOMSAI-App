import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/suggestions_chart/suggestions_chart.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/login/login_body.dto.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';

abstract class AIServiceInterface {
  Future<ConsumptionOptimizationsForecastDto>
      getPhotovoltaicSelfConsumptionOptimizerForecast(
    ConsumptionOptimizationsForecastBodyDto optimizationsForecastBody,
    String unit,
  );

  Future<DailyPlanDto> getDailyPlan(
    DailyPlanBodyDto dailyPlanBodyDto,
    int deviceNumber,
    List<String> entitysType,
  );

  Future<AiServiceAuth?> getToken(
    LoginBodyDto loginBodyDto,
  );

  Future<AiServiceAuth?> refreshToken(
    AiServiceAuth aiServiceAuth,
  );

  Future subscribeToBeta(
    LoginBodyDto loginBodyDto,
  );

  Future<List<PhotovoltaicForecastDto>> getPhotovoltaicForecast(
    PhotovoltaicForecastBodyDto dailyPlanBodyDto,
  );

  Future<SuggestionsChartDto> getSuggestionsChart();
}
