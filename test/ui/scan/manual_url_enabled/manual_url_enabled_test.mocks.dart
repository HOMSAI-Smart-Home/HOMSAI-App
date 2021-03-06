// Mocks generated by Mockito 5.2.0 from annotations
// in homsai/test/ui/scan/manual_url_enabled/manual_url_enabled_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:homsai/business/ai_service/ai_service.repository.dart' as _i9;
import 'package:homsai/business/home_assistant/home_assistant.repository.dart'
    as _i16;
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart'
    as _i4;
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_body.dto.dart'
    as _i13;
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart'
    as _i3;
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast_body.dto.dart'
    as _i12;
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic.dto.dart'
    as _i14;
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic_body.dto.dart'
    as _i15;
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/suggestions_chart/suggestions_chart.dto.dart'
    as _i5;
import 'package:homsai/datastore/DTOs/remote/ai_service/login/login_body.dto.dart'
    as _i11;
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart' as _i18;
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart'
    as _i19;
import 'package:homsai/datastore/DTOs/remote/logbook/logbook.dto.dart' as _i8;
import 'package:homsai/datastore/DTOs/remote/logbook/logbook_body.dto.dart'
    as _i20;
import 'package:homsai/datastore/models/ai_service_auth.model.dart' as _i10;
import 'package:homsai/datastore/models/database/plant.entity.dart' as _i17;
import 'package:homsai/datastore/models/home_assistant_auth.model.dart' as _i6;
import 'package:homsai/datastore/remote/rest/remote.Interface.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeRemoteInterface_0 extends _i1.Fake implements _i2.RemoteInterface {}

class _FakeConsumptionOptimizationsForecastDto_1 extends _i1.Fake
    implements _i3.ConsumptionOptimizationsForecastDto {}

class _FakeDailyPlanDto_2 extends _i1.Fake implements _i4.DailyPlanDto {}

class _FakeSuggestionsChartDto_3 extends _i1.Fake
    implements _i5.SuggestionsChartDto {}

class _FakeHomeAssistantAuth_4 extends _i1.Fake
    implements _i6.HomeAssistantAuth {}

class _FakeStreamSubscription_5<T> extends _i1.Fake
    implements _i7.StreamSubscription<T> {}

class _FakeUri_6 extends _i1.Fake implements Uri {}

class _FakeLogbookDto_7 extends _i1.Fake implements _i8.LogbookDto {}

/// A class which mocks [AIServiceRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAIServiceRepository extends _i1.Mock
    implements _i9.AIServiceRepository {
  MockAIServiceRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.RemoteInterface get remoteInterface =>
      (super.noSuchMethod(Invocation.getter(#remoteInterface),
          returnValue: _FakeRemoteInterface_0()) as _i2.RemoteInterface);
  @override
  _i7.Future<_i10.AiServiceAuth?> getToken(_i11.LoginBodyDto? loginBodyDto) =>
      (super.noSuchMethod(Invocation.method(#getToken, [loginBodyDto]),
              returnValue: Future<_i10.AiServiceAuth?>.value())
          as _i7.Future<_i10.AiServiceAuth?>);
  @override
  _i7.Future<_i10.AiServiceAuth?> refreshToken(
          _i10.AiServiceAuth? aiServiceAuth) =>
      (super.noSuchMethod(Invocation.method(#refreshToken, [aiServiceAuth]),
              returnValue: Future<_i10.AiServiceAuth?>.value())
          as _i7.Future<_i10.AiServiceAuth?>);
  @override
  _i7.Future<_i3.ConsumptionOptimizationsForecastDto>
      getPhotovoltaicSelfConsumptionOptimizerForecast(
              _i12.ConsumptionOptimizationsForecastBodyDto?
                  optimizationsForecastBody,
              String? unit) =>
          (super.noSuchMethod(
              Invocation.method(
                  #getPhotovoltaicSelfConsumptionOptimizerForecast,
                  [optimizationsForecastBody, unit]),
              returnValue: Future<_i3.ConsumptionOptimizationsForecastDto>.value(
                  _FakeConsumptionOptimizationsForecastDto_1())) as _i7
              .Future<_i3.ConsumptionOptimizationsForecastDto>);
  @override
  _i7.Future<dynamic> subscribeToBeta(_i11.LoginBodyDto? loginBodyDto) =>
      (super.noSuchMethod(Invocation.method(#subscribeToBeta, [loginBodyDto]),
          returnValue: Future<dynamic>.value()) as _i7.Future<dynamic>);
  @override
  _i7.Future<_i4.DailyPlanDto> getDailyPlan(
          _i13.DailyPlanBodyDto? dailyPlanBodyDto,
          int? deviceNumber,
          List<String>? entitysType) =>
      (super.noSuchMethod(
              Invocation.method(
                  #getDailyPlan, [dailyPlanBodyDto, deviceNumber, entitysType]),
              returnValue:
                  Future<_i4.DailyPlanDto>.value(_FakeDailyPlanDto_2()))
          as _i7.Future<_i4.DailyPlanDto>);
  @override
  _i7.Future<List<_i14.PhotovoltaicForecastDto>> getPhotovoltaicForecast(
          _i15.PhotovoltaicForecastBodyDto? dailyPlanBodyDto) =>
      (super.noSuchMethod(
              Invocation.method(#getPhotovoltaicForecast, [dailyPlanBodyDto]),
              returnValue: Future<List<_i14.PhotovoltaicForecastDto>>.value(
                  <_i14.PhotovoltaicForecastDto>[]))
          as _i7.Future<List<_i14.PhotovoltaicForecastDto>>);
  @override
  _i7.Future<_i5.SuggestionsChartDto> getSuggestionsChart() =>
      (super.noSuchMethod(Invocation.method(#getSuggestionsChart, []),
              returnValue: Future<_i5.SuggestionsChartDto>.value(
                  _FakeSuggestionsChartDto_3()))
          as _i7.Future<_i5.SuggestionsChartDto>);
}

/// A class which mocks [HomeAssistantRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeAssistantRepository extends _i1.Mock
    implements _i16.HomeAssistantRepository {
  MockHomeAssistantRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i6.HomeAssistantAuth> authenticate(
          {Uri? baseUrl, Uri? fallback}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #authenticate, [], {#baseUrl: baseUrl, #fallback: fallback}),
              returnValue: Future<_i6.HomeAssistantAuth>.value(
                  _FakeHomeAssistantAuth_4()))
          as _i7.Future<_i6.HomeAssistantAuth>);
  @override
  _i7.Future<_i6.HomeAssistantAuth> authenticateHomeAssistant({Uri? url}) =>
      (super.noSuchMethod(
              Invocation.method(#authenticateHomeAssistant, [], {#url: url}),
              returnValue: Future<_i6.HomeAssistantAuth>.value(
                  _FakeHomeAssistantAuth_4()))
          as _i7.Future<_i6.HomeAssistantAuth>);
  @override
  _i7.Future<_i7.StreamSubscription<String>> scan(
          {void Function(String)? onData,
          Function? onError,
          Duration? timeout}) =>
      (super.noSuchMethod(
              Invocation.method(#scan, [],
                  {#onData: onData, #onError: onError, #timeout: timeout}),
              returnValue: Future<_i7.StreamSubscription<String>>.value(
                  _FakeStreamSubscription_5<String>()))
          as _i7.Future<_i7.StreamSubscription<String>>);
  @override
  _i7.Future<Uri> canConnectToHomeAssistant(
          {Uri? baseUrl,
          Uri? fallback,
          Duration? timeout = const Duration(seconds: 2)}) =>
      (super.noSuchMethod(
          Invocation.method(#canConnectToHomeAssistant, [],
              {#baseUrl: baseUrl, #fallback: fallback, #timeout: timeout}),
          returnValue: Future<Uri>.value(_FakeUri_6())) as _i7.Future<Uri>);
  @override
  _i7.Future<_i6.HomeAssistantAuth> refreshToken(
          {Uri? url, Duration? timeout = const Duration(seconds: 2)}) =>
      (super.noSuchMethod(
          Invocation.method(#refreshToken, [], {#url: url, #timeout: timeout}),
          returnValue: Future<_i6.HomeAssistantAuth>.value(
              _FakeHomeAssistantAuth_4())) as _i7
          .Future<_i6.HomeAssistantAuth>);
  @override
  _i7.Future<dynamic> revokeToken(
          {_i17.Plant? plant,
          Duration? timeout = const Duration(seconds: 2)}) =>
      (super.noSuchMethod(
          Invocation.method(
              #revokeToken, [], {#plant: plant, #timeout: timeout}),
          returnValue: Future<dynamic>.value()) as _i7.Future<dynamic>);
  @override
  _i7.Future<List<_i18.HistoryDto>> getHistory(
          {_i17.Plant? plant,
          _i19.HistoryBodyDto? historyBodyDto,
          Duration? timeout = const Duration(seconds: 10)}) =>
      (super.noSuchMethod(
              Invocation.method(#getHistory, [], {
                #plant: plant,
                #historyBodyDto: historyBodyDto,
                #timeout: timeout
              }),
              returnValue:
                  Future<List<_i18.HistoryDto>>.value(<_i18.HistoryDto>[]))
          as _i7.Future<List<_i18.HistoryDto>>);
  @override
  _i7.Future<_i8.LogbookDto> getLogBook(
          {_i17.Plant? plant,
          DateTime? start,
          _i20.LogbookBodyDto? logbookBodyDto}) =>
      (super.noSuchMethod(
              Invocation.method(#getLogBook, [], {
                #plant: plant,
                #start: start,
                #logbookBodyDto: logbookBodyDto
              }),
              returnValue: Future<_i8.LogbookDto>.value(_FakeLogbookDto_7()))
          as _i7.Future<_i8.LogbookDto>);
}
