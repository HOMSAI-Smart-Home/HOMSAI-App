import 'dart:io';

import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/log.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/login/login.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/login/login_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';
import 'package:uuid/uuid.dart';

class AIServiceRepository implements AIServiceInterface {
  final RemoteInterface remoteInterface = getIt.get<RemoteInterface>();
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  final Uuid uuid = const Uuid();
  final Map<String, String> _anonToPlain = {};
  final Map<String, String> _plainToAnon = {};

  Map<String, String> _getHeader() {
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    final AiServiceAuth? token = appPreferences.getAiServiceToken();
    if (token != null && token.token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer ' + token.token!;
    }

    return headers;
  }

  @override
  Future<AiServiceAuth?> getToken(
    LoginBodyDto loginBodyDto,
  ) async {
    Map<String, String> headers = _getHeader();
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
      headers: _getHeader(),
      body: optimizationsForecastBody.toJson(),
    );
    appPreferences.setOptimizationForecast(
        ConsumptionOptimizationsForecastDto.fromJson(result));
    return ConsumptionOptimizationsForecastDto.fromJson(result);
  }

  @override
  Future subscribeToBeta(LoginBodyDto loginBodyDto) async {
    Map<String, dynamic> result = await remoteInterface.post(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServiceSubscribeToBetaPath,
      ),
      headers: _getHeader(),
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
    dailyPlanBodyDto = _anonymizeDayliPlanBodyDto(dailyPlanBodyDto);
    Map<String, dynamic> result = await remoteInterface.post(
      Uri.parse(ApiProprties.aIServiceBaseUrl).replace(
        path: ApiProprties.aiServiceDailyPlanPath,
        queryParameters: {"n": deviceNumber, "device": entitysType},
      ),
      headers: _getHeader(),
      body: dailyPlanBodyDto.toJson(),
    );
    return _deanonymizeDayliPlanDto(DailyPlanDto.fromJson(result));
  }

  DailyPlanBodyDto _anonymizeDayliPlanBodyDto(
      DailyPlanBodyDto dailyPlanBodyDto) {
    DailyPlanBodyDto anonymizedDailyPlanBodyDto =
        DailyPlanBodyDto.fromJson(dailyPlanBodyDto.toJson());

    for (LogDto dailyLog in anonymizedDailyPlanBodyDto.dailyLog) {
      List<String> entity = dailyLog.entityId!.split('.');
      dailyLog.name = _toAnon(dailyLog.name!);
      dailyLog.entityId = '${_toAnon(entity[0])}.${_toAnon(entity[1])}';
    }

    return anonymizedDailyPlanBodyDto;
  }

  DailyPlanDto _deanonymizeDayliPlanDto(DailyPlanDto dailyPlanDto) {
    DailyPlanDto deanonymizedDailyPlanDto =
        DailyPlanDto.fromJson(dailyPlanDto.toJson());

    for (HourDto dailyLog in deanonymizedDailyPlanDto.dailyPlan) {
      for (DeviceDto deviceDto in dailyLog.deviceId) {
        List<String> entity = deviceDto.entityId!.split('.');
        deviceDto.entityId =
            '${_anonToPlain[entity[0]]}.${_anonToPlain[entity[1]]}';
      }
    }

    return deanonymizedDailyPlanDto;
  }

  String _toAnon(String plain) {
    if (!_plainToAnon.containsKey(plain)) {
      _plainToAnon[plain] = uuid.v4();
      _anonToPlain[_plainToAnon[plain]!] = plain;
    }

    return _plainToAnon[plain]!;
  }
}
