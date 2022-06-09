import 'dart:io';

import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/crossconcern/utilities/util/anonimizer.util.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_cached.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/suggestions_chart/suggestions_chart.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/login/login.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/login/login_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/error/error.dto.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';

class AIServiceRepository implements AIServiceInterface {
  final RemoteInterface remoteInterface = getIt.get<RemoteInterface>();
  final AppPreferencesInterface _appPreferences =
      getIt.get<AppPreferencesInterface>();

  Map<String, String> _getHeaders() {
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    final AiServiceAuth? token = _appPreferences.getAiServiceToken();
    if (token != null && token.token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ' + token.token!;
    }

    return headers;
  }

  @override
  Future<AiServiceAuth?> getToken(
    LoginBodyDto loginBodyDto,
  ) async {
    Map<String, String> headers = _getHeaders();
    headers["X-Requested-With"] = "XMLHttpRequest";

    Map<String, dynamic> result = await remoteInterface.post(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServiceLoginPath,
      ),
      headers: headers,
      body: loginBodyDto.toJson(),
    );

    LoginDto loginDto = LoginDto.fromJson(result);

    if (loginDto.code != null) {
      if (loginDto.code == 102) {
        throw Exception(loginDto.message);
      }
      return null;
    }

    return AiServiceAuth.fromJson(loginDto.toJson());
  }

  @override
  Future<AiServiceAuth?> refreshToken(
    AiServiceAuth aiServiceAuth,
  ) async {
    Map<String, String> headers = _getHeaders();
    headers["X-Requested-With"] = "XMLHttpRequest";
    headers[HttpHeaders.authorizationHeader] =
        'Bearer ' + aiServiceAuth.refreshToken!;

    Map<String, dynamic> result = await remoteInterface.get(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServiceRefreshTokenPath,
      ),
      headers: headers,
    );

    LoginDto loginDto = LoginDto.fromJson(result);

    if (loginDto.code != null) {
      if (loginDto.code == 102) {
        throw Exception(loginDto.message);
      }
      return null;
    }

    return aiServiceAuth.copyWith(
      token: loginDto.token,
    );
  }

  @override
  Future<ConsumptionOptimizationsForecastDto>
      getPhotovoltaicSelfConsumptionOptimizerForecast(
    ConsumptionOptimizationsForecastBodyDto optimizationsForecastBody,
    String unit,
  ) async {
    Map<String, dynamic> result = await remoteInterface.post(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path:
            ApiProprties.aiServicePhotovoltaicSelfConsumptionOptimizerForecast,
        queryParameters: {"unit": unit},
      ),
      headers: _getHeaders(),
      body: optimizationsForecastBody.toJson(),
    );

    if (await _wasRefresh(result)) {
      return getPhotovoltaicSelfConsumptionOptimizerForecast(
          optimizationsForecastBody, unit);
    }

    return ConsumptionOptimizationsForecastDto.fromJson(result);
  }

  @override
  Future subscribeToBeta(
    LoginBodyDto loginBodyDto,
  ) async {
    Map<String, dynamic> result = await remoteInterface.post(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServiceSubscribeToBetaPath,
      ),
      headers: _getHeaders(),
      body: loginBodyDto.toJson(),
    );

    LoginDto loginDto = LoginDto.fromJson(result);

    if (loginDto.code != null) {
      if (loginDto.code == 20) {
        throw Exception(loginDto.message);
      }
      throw Exception('${loginDto.code}: ${loginDto.message}');
    }
  }

  @override
  Future<DailyPlanDto> getDailyPlan(
    DailyPlanBodyDto dailyPlanBodyDto,
    int deviceNumber,
    List<String> entitysType,
  ) async {
    final Anonymizer anonymizer = Anonymizer();

    Map<String, dynamic> result = await remoteInterface.post(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServiceDailyPlanPath,
        queryParameters: {
          "n": deviceNumber.toString(),
          "device": anonymizer.cipherAll(entitysType)
        },
      ),
      headers: _getHeaders(),
      body: dailyPlanBodyDto.cipher(anonymizer).toJson()["dailyLog"],
    );
    if (await _wasRefresh(result)) {
      return getDailyPlan(
        dailyPlanBodyDto,
        deviceNumber,
        entitysType,
      );
    }

    final dailyPlan =
        DailyPlanDto.fromResult(result["data"]).decipher(anonymizer);

    DateTime today = DateTime.now();
    today = DateTime(
      today.year,
      today.month,
      today.day,
    );

    DailyPlanCachedDto dailyPlanCached = DailyPlanCachedDto(
      dailyPlan,
      today,
    );

    _appPreferences.setDailyPlan(
      dailyPlanCached,
    );

    return dailyPlan;
  }

  @override
  Future<List<PhotovoltaicForecastDto>> getPhotovoltaicForecast(
    PhotovoltaicForecastBodyDto dailyPlanBodyDto,
  ) async {
    Map<String, dynamic> result = await remoteInterface.get(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServicePhotovoltaicForecast,
        queryParameters: dailyPlanBodyDto.toJson().map(
              (key, value) => MapEntry(
                key,
                value.toString(),
              ),
            ),
      ),
      headers: _getHeaders(),
    );

    if (await _wasRefresh(result)) {
      return getPhotovoltaicForecast(
        dailyPlanBodyDto,
      );
    }

    return PhotovoltaicForecastDto.fromList(result["data"]);
  }

  @override
  Future<SuggestionsChartDto> getSuggestionsChart() async {
    Map<String, dynamic> result = await remoteInterface.get(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServiceSuggestionsChart,
      ),
      headers: _getHeaders(),
    );

    if (await _wasRefresh(result)) {
      return getSuggestionsChart();
    }

    return SuggestionsChartDto.fromJson(result);
  }

  Future<bool> _wasRefresh(
    Map<String, dynamic> result,
  ) async {
    final error = ErrorDto.fromJson(result);
    AiServiceAuth aiServiceAuth = _appPreferences.getAiServiceToken()!;

    if (error.code != null && (error.code! == 401 || error.code! == 103)) {
      aiServiceAuth = (await refreshToken(aiServiceAuth))!;
      _appPreferences.setAiServicetToken(aiServiceAuth);
      return true;
    }
    return false;
  }
}
