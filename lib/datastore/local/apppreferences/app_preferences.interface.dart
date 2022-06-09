import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_cached.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class AppPreferencesInterface {
  Future<void> initialize();

  bool canSkipIntroduction();
  void setIntroduction(bool canSkip);
  Future<void> resetIntroduction();

  HomeAssistantAuth? getHomeAssistantToken();
  void setHomeAssistantToken(HomeAssistantAuth homeAssistantAuth);
  Future<void> resetHomeAssistantToken();

  AiServiceAuth? getAiServiceToken();
  void setAiServicetToken(AiServiceAuth aiServiceAuth);
  Future<void> resetAiServiceToken();

  Future<void> resetUserId();
  void setUserId(String id);
  String? getUserId();

  Future<void> logout({bool deleteUser});

  void setOptimizationForecast(ConsumptionOptimizationsForecastDto forecastDto);
  ConsumptionOptimizationsForecastDto? getOptimizationForecast();
  Future<void> resetOptimizationForecast();

  void setConsumptionInfo(List<HistoryDto> consumptionInfo);
  List<HistoryDto>? getConsumptionInfo();
  Future<void> resetConsumptionInfo();

  void setProductionInfo(List<HistoryDto> productionInfo);
  List<HistoryDto>? getProductionInfo();
  Future<void> resetProductionInfo();

  void setDailyPlan(DailyPlanCachedDto dailyPlan);
  DailyPlanCachedDto? getDailyPlan();
  Future<void> resetDailyPlan();

  void setBatteryInfo(List<HistoryDto> batteryInfo);
  List<HistoryDto>? getBatteryInfo();
  Future<void> resetBatteryInfo();
}
