import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_cached.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class AppPreferencesInterface {
  Future<void> initialize();

  bool canSkipIntroduction();
  void setIntroduction(bool canSkip);
  void resetIntroduction();

  HomeAssistantAuth? getHomeAssistantToken();
  void setHomeAssistantToken(HomeAssistantAuth homeAssistantAuth);
  void resetHomeAssistantToken();

  AiServiceAuth? getAiServiceToken();
  void setAiServicetToken(AiServiceAuth aiServiceAuth);
  void resetAiServiceToken();

  void resetUserId();
  void setUserId(String id);
  String? getUserId();

  void logout();

  void setOptimizationForecast(ConsumptionOptimizationsForecastDto forecastDto);
  ConsumptionOptimizationsForecastDto? getOptimizationForecast();
  void resetOptimizationForecast();

  void setConsumptionInfo(List<HistoryDto> consumptionInfo);
  List<HistoryDto>? getConsumptionInfo();
  void resetConsumptionInfo();

  void setProductionInfo(List<HistoryDto> productionInfo);
  List<HistoryDto>? getProductionInfo();
  void resetProductionInfo();

  void setDailyPlan(DailyPlanCachedDto dailyPlan);
  DailyPlanCachedDto? getDailyPlan();
  void resetDailyPlan();
}
