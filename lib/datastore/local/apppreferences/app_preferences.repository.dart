import 'dart:convert';

import 'package:homsai/crossconcern/utilities/properties/app_preference.proprties.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast.dto.dart';
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
    return HomeAssistantAuth.fromJson(jsonDecode(preferences?.getString(
            AppPreferencesProperties.prefKeyHomeAssistantAccessToken) ??
        "{}"));
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
        jsonEncode(token));
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
        AppPreferencesProperties.prefKeySkipIntroduction, canSkip);
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
    return AiServiceAuth.fromJson(jsonDecode(preferences
            ?.getString(AppPreferencesProperties.prefKeyAiServiceAccessToken) ??
        "{}"));
  }

  @override
  void resetAiServiceToken() {
    preferences?.remove(AppPreferencesProperties.prefKeyAiServiceAccessToken);
  }

  @override
  void setAiServicetToken(AiServiceAuth token) {
    preferences?.setString(AppPreferencesProperties.prefKeyAiServiceAccessToken,
        jsonEncode(token));
  }

  @override
  void logout() {
    resetUserId();
    resetHomeAssistantToken();
    resetAiServiceToken();
  }

  @override
  void setOptimizationForecast(
      ConsumptionOptimizationsForecastDto forecastDto) {
    preferences?.setString(AppPreferencesProperties.prefOptimizationForecast,
        jsonEncode(forecastDto));
  }

  @override
  ConsumptionOptimizationsForecastDto? getOptimizationForecast() {
    final forecast = preferences
        ?.getString(AppPreferencesProperties.prefOptimizationForecast);
    return forecast != null
        ? ConsumptionOptimizationsForecastDto.fromJson(jsonDecode(forecast))
        : null;
  }

  @override
  void resetOptimizationForecast() {
    preferences?.remove(AppPreferencesProperties.prefOptimizationForecast);
  }
}
