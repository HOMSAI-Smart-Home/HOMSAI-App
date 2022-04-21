import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/components/charts/daily_consumption_chart.widget.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/utilities/util/plot.util.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/consumption_optimizations_forecast/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:timezone/timezone.dart';

part 'home.event.dart';
part 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeAssistantWebSocketRepository webSocketRepository =
      getIt.get<HomeAssistantWebSocketRepository>();

  final AIServiceInterface aiServiceInterface = getIt.get<AIServiceInterface>();

  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  HomeBloc() : super(const HomeState()) {
    on<ConnectWebSocket>(_onWebsocketConnect);
    on<FetchStates>(_onFetchState);
    on<FetchedLights>(_onFetchedLights);
    on<FetchHistory>(_onFetchHistory);
    on<ToggleConsumptionOptimazedPlot>(_onToggleConsumptionOptimazedPlot);
    add(FetchHistory());
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
  }

  void _onWebsocketConnect(
      ConnectWebSocket event, Emitter<HomeState> emit) async {
    HomeAssistantAuth? auth = appPreferencesInterface.getHomeAssistantToken();
    if (!webSocketRepository.isConnected() && auth != null) {
      webSocketRepository.connect(_getUrl(auth.localUrl, auth.remoteUrl));
    }
  }

  Uri _getUrl(String localUrl, String remoteUrl) {
    return localUrl != "" ? Uri.parse(localUrl) : Uri.parse(remoteUrl);
  }

  void _onFetchState(FetchStates event, Emitter<HomeState> emit) {
    webSocketRepository.fetchingStates(
      WebSocketSubscriber((res) {
        add(FetchedLights(entities: res));
      }),
    );
  }

  void _onFetchedLights(FetchedLights event, Emitter<HomeState> emit) async {
    final plant = await appDatabase.plantDao.getActivePlant();
    final entities = await appDatabase.plantDao.getAllEntities(plant!.id!);
    List<LightEntity> lights;
    if (entities.isEmpty) {
      await appDatabase.homeAssitantDao
          .insertEntities(plant.id!, event.entities.getEntities<Entity>());

      lights = event.entities.getEntities<LightEntity>();
    } else {
      lights = entities.getEntities<LightEntity>();
    }

    emit(state.copyWith(lights: lights));
  }

  void _onToggleConsumptionOptimazedPlot(
      ToggleConsumptionOptimazedPlot event, Emitter<HomeState> emit) {
    List<FlSpot> autoConsumption;
    if (event.isOptimized) {
      autoConsumption =
          state.optimizedConsumptionPlot!.intersect(state.productionPlot!);
    } else {
      autoConsumption = state.consumptionPlot!.intersect(state.productionPlot!);
    }

    emit(state.copyWith(
        autoConsumption: autoConsumption, isPlotOptimized: event.isOptimized));
  }

  void _onFetchHistory(FetchHistory event, Emitter<HomeState> emit) async {
    final plant = await appDatabase.plantDao.getActivePlant();
    if (plant != null) {
      Configuration? configuration = await appDatabase.plantDao
          .getConfiguration(plant.id!, appDatabase.configurationDao);

      getIt.registerLazySingleton<Location>(
          () => getLocation(configuration!.timezone));

      final consumptionInfo =
          await _getPlotInfoFromSensor(plant.consumptionSensor, plant.url);
      final productionInfo =
          await _getPlotInfoFromSensor(plant.productionSensor, plant.url);

      final productionSensor = await appDatabase.homeAssitantDao
          .findEntity<MesurableSensorEntity>(
              plant.id!, plant.productionSensor!);
      final consumptionSensor = await appDatabase.homeAssitantDao
          .findEntity<MesurableSensorEntity>(
              plant.id!, plant.consumptionSensor!);

      List<FlSpot> autoConsumption = [];
      ConsumptionOptimizationsForecastDto? consumptionForecast;
      PlotInfo? optimizedInfo;
      if (consumptionInfo.plot.isNotEmpty && productionInfo.plot.isNotEmpty) {
        autoConsumption = consumptionInfo.plot.intersect(productionInfo.plot);
        consumptionForecast = await aiServiceInterface
            .getPhotovoltaicSelfConsumptionOptimizerForecast(
                ConsumptionOptimizationsForecastBodyDto(
                  consumptionInfo.history,
                  consumptionSensor!.unitMesurement,
                  productionInfo.history,
                  productionSensor!.unitMesurement,
                ),
                configuration!.unitSystemType);
        optimizedInfo =
            _getPlotInfo(consumptionForecast.optimizedGeneralPowerMeterData);
      }

      emit(state.copyWith(
        consumptionSensor: consumptionSensor,
        productionSensor: productionSensor,
        consumptionPlot: consumptionInfo.plot.isNotEmpty
            ? consumptionInfo.plot
            : DailyConsumptionChart.emptyPlot,
        productionPlot: productionInfo.plot.isNotEmpty
            ? productionInfo.plot
            : DailyConsumptionChart.emptyPlot,
        optimizedConsumptionPlot:
            optimizedInfo?.plot ?? DailyConsumptionChart.emptyPlot,
        autoConsumption: autoConsumption,
        balance: consumptionForecast?.withoutHomsai,
        optimizedBalance: consumptionForecast?.withHomsai,
        minOffset: minOffset(
          consumptionInfo.minRange,
          productionInfo.minRange,
          optimizedInfo?.minRange,
        ),
        maxOffset: maxOffset(
          consumptionInfo.maxRange,
          productionInfo.maxRange,
          optimizedInfo?.maxRange,
        ),
      ));
    }
  }

  Offset minOffset(Offset a, Offset b, Offset? c) {
    final t = a <= b ? a : b;
    return c == null || t <= c ? t : c;
  }

  Offset maxOffset(Offset a, Offset b, Offset? c) {
    final t = a >= b ? a : b;
    return c == null || t >= c ? t : c;
  }

  Future<PlotInfo> _getPlotInfoFromSensor(String? sensor, String url) async {
    PlotInfo info =
        PlotInfo(maxRange: Offset(Duration.minutesPerDay.toDouble(), 4));
    if (sensor == null) return info;

    final historyBodyDto = HistoryBodyDto(sensor, minimalResponse: true);
    final history = await homeAssistantRepository.getHistory(Uri.parse(url),
        historyBodyDto: historyBodyDto);

    return _getPlotInfo(history);
  }

  PlotInfo _getPlotInfo(List<HistoryDto> history) {
    PlotInfo info =
        PlotInfo(maxRange: Offset(Duration.minutesPerDay.toDouble(), 4));

    final plot = _parsePlot(history);

    return info.copyWith(
      plot: plot,
      minRange: Offset(plot.first.x, max(0, plot.min.y)),
      maxRange: Offset(plot.last.x, plot.max.y),
      history: history
          .where((entity) => double.tryParse(entity.state) != null)
          .toList(),
    );
  }

  List<FlSpot> _parsePlot(List<HistoryDto> results) {
    final plot = results
        .map(
          (result) => FlSpot(
            (result.lastChanged.minute +
                    result.lastChanged.hour * Duration.minutesPerHour)
                .toDouble(),
            double.tryParse(result.state) ?? double.negativeInfinity,
          ),
        )
        .where((spot) => spot.y != double.negativeInfinity)
        .toList();
    return plot.sample(
        plot[0].x, plot[0].x + const Duration(days: 1).inMinutes, 10);
  }
}

class PlotInfo {
  final List<FlSpot> plot;
  final Offset minRange;
  final Offset maxRange;
  final List<HistoryDto> history;

  PlotInfo({
    this.plot = const [],
    this.minRange = Offset.zero,
    this.maxRange = Offset.infinite,
    this.history = const [],
  });

  PlotInfo copyWith({
    List<FlSpot>? plot,
    Offset? minRange,
    Offset? maxRange,
    List<HistoryDto>? history,
  }) =>
      PlotInfo(
        plot: plot ?? this.plot,
        minRange: minRange ?? this.minRange,
        maxRange: maxRange ?? this.maxRange,
        history: history ?? this.history,
      );
}
