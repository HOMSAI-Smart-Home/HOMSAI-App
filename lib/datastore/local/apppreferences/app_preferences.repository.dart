import 'dart:convert';

import 'package:homsai/crossconcern/utilities/properties/app_preference.proprties.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_cached.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.interface.dart';

class AppPreferences implements AppPreferencesInterface {
  SharedPreferences? preferences;

  @override
  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  HomeAssistantAuth? getHomeAssistantToken() {
    final json = preferences
        ?.getString(AppPreferencesProperties.prefKeyHomeAssistantAccessToken);
    if (json == null) return null;
    return HomeAssistantAuth.fromJson(jsonDecode(json));
  }

  @override
  void resetHomeAssistantToken() {
    preferences
        ?.remove(AppPreferencesProperties.prefKeyHomeAssistantAccessToken);
  }

  @override
  void setHomeAssistantToken(HomeAssistantAuth token) {
    preferences?.setString(
      AppPreferencesProperties.prefKeyHomeAssistantAccessToken,
      jsonEncode(token),
    );
  }

  @override
  bool canSkipIntroduction() {
    return preferences
            ?.getBool(AppPreferencesProperties.prefKeySkipIntroduction) ??
        false;
  }

  @override
  void resetIntroduction() {
    preferences?.remove(AppPreferencesProperties.prefKeySkipIntroduction);
  }

  @override
  void setIntroduction(bool canSkip) {
    preferences?.setBool(
      AppPreferencesProperties.prefKeySkipIntroduction,
      canSkip,
    );
  }

  @override
  void resetUserId() {
    preferences?.remove(AppPreferencesProperties.prefKeyUserId);
  }

  @override
  void setUserId(String id) {
    preferences?.setString(AppPreferencesProperties.prefKeyUserId, id);
  }

  @override
  String? getUserId() {
    return preferences?.getString(AppPreferencesProperties.prefKeyUserId);
  }

  @override
  AiServiceAuth? getAiServiceToken() {
    final json = preferences
        ?.getString(AppPreferencesProperties.prefKeyAiServiceAccessToken);
    if (json == null) return null;
    return AiServiceAuth.fromJson(jsonDecode(json));
  }

  @override
  void resetAiServiceToken() {
    preferences?.remove(AppPreferencesProperties.prefKeyAiServiceAccessToken);
  }

  @override
  void setAiServicetToken(AiServiceAuth token) {
    preferences?.setString(
      AppPreferencesProperties.prefKeyAiServiceAccessToken,
      jsonEncode(token),
    );
  }

  @override
  void logout({bool deleteUser=true}) {
    if(deleteUser) resetUserId();
    resetHomeAssistantToken();
    resetAiServiceToken();
  }

  @override
  void setOptimizationForecast(
      ConsumptionOptimizationsForecastDto forecastDto) {
    preferences?.setString(
      AppPreferencesProperties.prefOptimizationForecast,
      jsonEncode(forecastDto),
    );
  }

  @override
  ConsumptionOptimizationsForecastDto? getOptimizationForecast() {
    final forecast = preferences
        ?.getString(AppPreferencesProperties.prefOptimizationForecast);
    if (forecast == null) return null;
    return ConsumptionOptimizationsForecastDto.fromJson(jsonDecode(forecast));
  }

  @override
  void resetOptimizationForecast() {
    preferences?.remove(AppPreferencesProperties.prefOptimizationForecast);
  }

  @override
  void setConsumptionInfo(List<HistoryDto> consumptionInfo) {
    preferences?.setString(
      AppPreferencesProperties.prefConsumptionInfo,
      jsonEncode(consumptionInfo),
    );
  }

  @override
  List<HistoryDto>? getConsumptionInfo() {
    final consumptionInfo =
        preferences?.getString(AppPreferencesProperties.prefConsumptionInfo);
    if (consumptionInfo == null) return null;
    return HistoryDto.fromList(jsonDecode(consumptionInfo));
  }

  @override
  void resetConsumptionInfo() {
    preferences?.remove(AppPreferencesProperties.prefConsumptionInfo);
  }

  @override
  void setProductionInfo(List<HistoryDto> productionInfo) {
    preferences?.setString(
      AppPreferencesProperties.prefProductionInfo,
      jsonEncode(productionInfo),
    );
  }

  @override
  List<HistoryDto>? getProductionInfo() {
    final productionInfo =
        preferences?.getString(AppPreferencesProperties.prefProductionInfo);
    if (productionInfo == null) return null;
    return HistoryDto.fromList(jsonDecode(productionInfo));
  }

  @override
  void resetProductionInfo() {
    preferences?.remove(AppPreferencesProperties.prefProductionInfo);
  }

  @override
  void setDailyPlan(DailyPlanCachedDto dailyPlan) {
    preferences?.setString(
      AppPreferencesProperties.prefDailyPlan,
      jsonEncode(
        dailyPlan.toJson(),
      ),
    );
  }

  @override
  DailyPlanCachedDto? getDailyPlan() {
    final dailyPlan =
        preferences?.getString(AppPreferencesProperties.prefDailyPlan);
    return dailyPlan != null
        ? DailyPlanCachedDto.fromJson(
            jsonDecode(dailyPlan),
          )
        : null;
  }

  @override
  void resetDailyPlan() {
    preferences?.remove(AppPreferencesProperties.prefDailyPlan);
  }

  @override
  List<HistoryDto>? getBatteryInfo() {
    final batteryInfo =
        preferences?.getString(AppPreferencesProperties.prefBatteryInfo);
    if (batteryInfo == null) return null;
    return HistoryDto.fromList(jsonDecode(batteryInfo));
  }

  @override
  void resetBatteryInfo() {
    preferences?.remove(AppPreferencesProperties.prefBatteryInfo);
  }

  @override
  void setBatteryInfo(List<HistoryDto> batteryInfo) {
    preferences?.setString(
      AppPreferencesProperties.prefBatteryInfo,
      jsonEncode(batteryInfo),
    );
  }
}
