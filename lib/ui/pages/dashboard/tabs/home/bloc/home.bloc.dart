import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/components/charts/daily_consumption_chart.widget.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/utilities/util/plot.util.dart';
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
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
    if (!webSocketRepository.isConnected() && auth?.url != null) {
      webSocketRepository.connect(Uri.parse(auth!.url));
    }
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
    emit(state.copyWith(isPlotOptimized: event.isOptimized));
  }

  void _onFetchHistory(FetchHistory event, Emitter<HomeState> emit) async {
    final plant = await appDatabase.plantDao.getActivePlant();
    if (plant != null) {
      Configuration? configuration = await appDatabase.plantDao
          .getConfiguration(plant.id!, appDatabase.configurationDao);

      getIt.registerLazySingleton<Location>(
          () => getLocation(configuration!.timezone));

      final consumptionInfo =
          await _getPlotInfo(plant.consumptionSensor, plant.url);
      final productionInfo =
          await _getPlotInfo(plant.productionSensor, plant.url);

      List<FlSpot> autoConsumption = [];
      if (consumptionInfo.plot.isNotEmpty && productionInfo.plot.isNotEmpty) {
        autoConsumption = consumptionInfo.plot.intersect(productionInfo.plot);
      }

      emit(state.copyWith(
        consumptionPlot: consumptionInfo.plot,
        productionPlot: productionInfo.plot,
        autoConsumption: autoConsumption,
        autoConsumptionOptimization: DailyConsumptionChart.emptyPlot,
        minOffset: consumptionInfo.minRange <= productionInfo.minRange
            ? consumptionInfo.minRange
            : productionInfo.minRange,
        maxOffset: consumptionInfo.maxRange <= productionInfo.maxRange
            ? productionInfo.maxRange
            : consumptionInfo.maxRange,
      ));
    }
  }

  Future<PlotInfo> _getPlotInfo(String? sensor, String url) async {
    PlotInfo info =
        PlotInfo(maxRange: Offset(Duration.minutesPerDay.toDouble(), 4));
    if (sensor == null) return info;

    final body =
        HistoryBodyDto(sensor, minimalResponse: true, noAttributes: true);
    final plot = await _getPlot(url, body);

    return info.copyWith(
      plot: plot,
      minRange: Offset(plot.first.x, max(0, plot.min.y)),
      maxRange: Offset(plot.last.x, plot.max.y),
    );
  }

  Future<List<FlSpot>> _getPlot(
      String url, HistoryBodyDto historyBodyDto) async {
    final results = await homeAssistantRepository.getHistory(Uri.parse(url),
        historyBodyDto: historyBodyDto);
    final plot = results
        .map(
          (result) => FlSpot(
            (result.lastChanged.minute +
                    result.lastChanged.hour * Duration.minutesPerHour)
                .toDouble(),
            double.tryParse(result.state) ?? 0,
          ),
        )
        .toList();
    return plot.sample(
        plot[0].x, plot[0].x + const Duration(days: 1).inMinutes, 10);
  }
}

class PlotInfo {
  final List<FlSpot> plot;
  final Offset minRange;
  final Offset maxRange;

  PlotInfo(
      {this.plot = const [],
      this.minRange = Offset.zero,
      this.maxRange = Offset.infinite});

  PlotInfo copyWith({
    List<FlSpot>? plot,
    Offset? minRange,
    Offset? maxRange,
  }) =>
      PlotInfo(
          plot: plot ?? this.plot,
          minRange: minRange ?? this.minRange,
          maxRange: maxRange ?? this.maxRange);
}
