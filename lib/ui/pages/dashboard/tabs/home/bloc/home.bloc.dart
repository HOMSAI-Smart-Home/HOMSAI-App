import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/components/alerts/general_alert.widget.dart';
import 'package:homsai/crossconcern/components/charts/daily_consumption_chart.widget.dart';
import 'package:homsai/crossconcern/exceptions/invalid_sensor.exception.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/utilities/properties/connection.properties.dart';
import 'package:homsai/crossconcern/utilities/util/plot.util.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/consumption_optimizations/consumption_optimizations_forecast_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/logbook/logbook.dto.dart';
import 'package:homsai/datastore/DTOs/remote/logbook/logbook_body.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/main.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';

part 'home.event.dart';
part 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NetworkManagerInterface _networkManagerInterface =
      getIt.get<NetworkManagerInterface>();

  final HomeAssistantWebSocketInterface webSocketRepository =
      getIt.get<HomeAssistantWebSocketInterface>();

  final AIServiceInterface aiServiceInterface = getIt.get<AIServiceInterface>();

  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  bool _active = true;

  HomeBloc() : super(const HomeState()) {
    on<FetchStates>(_onFetchState);
    on<FetchedLights>(_onFetchedLights);
    on<FetchHistory>(_onFetchHistory);
    on<FetchPhotovoltaicForecast>(_onFetchPhotovoltaicForecast);
    on<ToggleConsumptionOptimazedPlot>(_onToggleConsumptionOptimazedPlot);
    on<AddAlert>(_onAddAlert);
    on<RemoveAlert>(_onRemoveAlert);
    _networkManagerInterface.subscribe(
        NetworkManagerSubscriber((result) => {_checkConnection(result)}));
  }

  void _checkConnection(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.none:
        add(const AddAlert(
            NoInternetConnectionAlert(
                key: Key(ConnectionProperties.noInternetConnectionAlertKey)),
            ConnectionProperties.noInternetConnectionAlertKey));
        break;
      case ConnectivityResult.wifi:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.mobile:
        add(const RemoveAlert(
            ConnectionProperties.noInternetConnectionAlertKey));
        break;
      default:
        break;
    }
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
  }

  void _onFetchState(FetchStates event, Emitter<HomeState> emit) async {
    webSocketRepository.fetchingStates(
      WebSocketSubscriber((res) {
        if (_active) add(FetchedLights(entities: res));
      }),
    );
  }

  void _onAddAlert(AddAlert event, Emitter<HomeState> emit) async {
    final Map<String, Widget> alerts = Map.from(state.alerts);
    alerts.putIfAbsent(event.alertId, () => event.alert);
    emit(state.copyWith(alerts: alerts));
  }

  void _onRemoveAlert(RemoveAlert event, Emitter<HomeState> emit) async {
    final Map<String, Widget> alerts = Map.from(state.alerts);
    alerts.remove(event.alertId);
    emit(state.copyWith(alerts: alerts));
  }

  void _onFetchedLights(FetchedLights event, Emitter<HomeState> emit) async {
    final plant = await appDatabase.getPlant();
    if (plant != null && plant.id != null) {
      await appDatabase.homeAssitantDao.refreshPlantEntities(
          plant.id!, event.entities.getEntities<Entity>());
    }
    if (_active) {
      // appPreferencesInterface.resetLogBook();
      LogbookDto logBook;
      DailyPlanBodyDto dailyPlanBodyDto;
      DailyPlanDto dailyPlan;
      final dailyPlanCached = appPreferencesInterface.getDailyPlan();
      if (dailyPlanCached != null &&
          _checkIfDateIsYesterday(dailyPlanCached.dateFetched)) {
        dailyPlan = dailyPlanCached.dailyPlan;
      } else {
        DateTime today = DateTime.now();
        today = DateTime(
          today.year,
          today.month,
          today.day,
        );
        // TODO: Handle other devices
        logBook = await homeAssistantRepository.getLogBook(
          plant: plant!,
          start: _getOneWeekAgo(today),
          logbookBodyDto: LogbookBodyDto(
            endTime: today,
          ),
        );

        dailyPlanBodyDto = DailyPlanBodyDto.fromList(
          logBook.data,
        );

        dailyPlan = await aiServiceInterface.getDailyPlan(
          dailyPlanBodyDto,
          event.entities.getEntities<LightEntity>().length,
          [LightEntity.type],
        );
      }
      final lights = event.entities.getEntities<LightEntity>();
      final orderedDevices = _orderDevicesByDailyPlan(dailyPlan, lights);
      emit(state.copyWith(lights: orderedDevices));
    }
  }

  List<LightEntity> _orderDevicesByDailyPlan(
    DailyPlanDto dailyPlan,
    List<LightEntity> lights,
  ) {
    final currentHour = DateTime.now().hour;
    List<DeviceDto> currentDevicePlan =
        dailyPlan.dailyPlan[currentHour].deviceId;

    lights.sort((a, b) {
      return currentDevicePlan
              .indexWhere((element) => element.entityId == a.entityId) -
          currentDevicePlan
              .indexWhere((element) => element.entityId == b.entityId);
    });

    return lights;
  }

  void _onToggleConsumptionOptimazedPlot(
    ToggleConsumptionOptimazedPlot event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      autoConsumption: checkAutoConsumption(
        isOptimized: event.isOptimized,
        optimizedConsumption:
            PlotInfo(plot: state.optimizedConsumptionPlot ?? []),
        productionPlot: state.productionPlot!,
        consumptionPlot: state.consumptionPlot!,
      ),
      isPlotOptimized: event.isOptimized,
    ));
  }

  List<FlSpot> checkAutoConsumption({
    required bool isOptimized,
    required PlotInfo optimizedConsumption,
    required List<FlSpot> productionPlot,
    required List<FlSpot> consumptionPlot,
  }) {
    if (isOptimized) {
      return optimizedConsumption.plot.intersect(productionPlot);
    }
    return consumptionPlot.intersect(productionPlot);
  }

  DateTime _getOneWeekAgo(DateTime date) {
    DateTime oneWeekAgo = date.subtract(const Duration(days: 7));
    oneWeekAgo = DateTime(oneWeekAgo.year, oneWeekAgo.month, oneWeekAgo.day);
    return oneWeekAgo;
  }

  bool _checkIfDateIsYesterday(DateTime date) {
    // Check if the forecast date is yesterday
    var yesterday = DateTime.now().subtract(const Duration(days: 1));
    yesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
    return date.isAtSameMomentAs(yesterday);
  }

  void _onFetchHistory(FetchHistory event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final plant = await appDatabase.getPlant();
    if (plant != null) {
      try {
        Configuration? configuration = await appDatabase.getConfiguration();

        final consumptionInfo =
            await _getPlotInfoFromSensor(plant.consumptionSensor, plant, true);
        final productionInfo =
            await _getPlotInfoFromSensor(plant.productionSensor, plant, false);

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
          final forecasts = appPreferencesInterface.getOptimizationForecast();
          if (forecasts != null &&
              forecasts.optimizedGeneralPowerMeterData.isNotEmpty &&
              _checkIfDateIsYesterday(
                  forecasts.optimizedGeneralPowerMeterData[0].lastChanged)) {
            consumptionForecast = forecasts;
          } else {
            consumptionForecast = await aiServiceInterface
                .getPhotovoltaicSelfConsumptionOptimizerForecast(
                    ConsumptionOptimizationsForecastBodyDto(
                      consumptionInfo.history,
                      consumptionSensor!.unitMesurement,
                      productionInfo.history,
                      productionSensor!.unitMesurement,
                    ),
                    configuration!.unitSystemType);
          }
          optimizedInfo =
              _getPlotInfo(consumptionForecast.optimizedGeneralPowerMeterData);

          autoConsumption = checkAutoConsumption(
            isOptimized: state.isPlotOptimized,
            optimizedConsumption: optimizedInfo,
            consumptionPlot: consumptionInfo.plot,
            productionPlot: productionInfo.plot,
          );
        }

        if (_active) {
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
              isLoading: false));
        }
      } catch (e) {
        emit(HomeState(lights: state.lights));
      }
    }
  }

  void _onFetchPhotovoltaicForecast(
      FetchPhotovoltaicForecast event, Emitter<HomeState> emit) async {
    final plant = await appDatabase.getPlant();
    //TODO: handle else case
    if (plant != null &&
        plant.photovoltaicNominalPower != null &&
        plant.photovoltaicInstallationDate != null) {
      final photovoltaicForecast = await _getPhotovoltaicForecast(
        double.parse(plant.photovoltaicNominalPower!),
        plant.photovoltaicInstallationDate!.difference(DateTime.now()).inDays,
        plant.latitude,
        plant.longitude,
      );
      emit(state.copyWith(
        forecastData: photovoltaicForecast.data,
        forecastMinOffset: photovoltaicForecast.min,
        forecastMaxOffset: photovoltaicForecast.max,
      ));
    }
  }

  Future<PhotovoltaicForecastInfo> _getPhotovoltaicForecast(
      double photovoltaicNominalPower,
      int days,
      double latitude,
      double longitude) async {
    final photovoltaicForecast =
        await aiServiceInterface.getPhotovoltaicForecast(
      PhotovoltaicForecastBodyDto(
        photovoltaicNominalPower,
        days,
        latitude: latitude,
        longitude: longitude,
      ),
    );
    return _parsePhotovoltaicForecastInfo(photovoltaicForecast);
  }

  PhotovoltaicForecastInfo _parsePhotovoltaicForecastInfo(
      List<PhotovoltaicForecastDto> photovoltaicForecast) {
    final dataParsed =
        photovoltaicForecast.map((element) => element.toSpot).toList();
        
    return PhotovoltaicForecastInfo(
      data: dataParsed,
      min: Offset(dataParsed.first.x, max(0, dataParsed.min.y)),
      max: Offset(dataParsed.last.x, dataParsed.max.y),
    );
  }

  Offset minOffset(Offset a, Offset b, Offset? c) {
    final t = a <= b ? a : b;
    return c == null || t <= c ? t : c;
  }

  Offset maxOffset(Offset a, Offset b, Offset? c) {
    final t = a >= b ? a : b;
    return c == null || t >= c ? t : c;
  }

  Future<PlotInfo> _getPlotInfoFromSensor(
      String? sensor, Plant plant, bool isConsumption) async {
    if (sensor == null) throw InvalidSensorException();

    final historyBodyDto = HistoryBodyDto(sensor, minimalResponse: true);
    List<HistoryDto>? historyCached = getHistoryCached(isConsumption);
    List<HistoryDto> history;
    if (historyCached != null &&
        historyCached.isNotEmpty &&
        _checkIfDateIsYesterday(historyCached[0].lastChanged)) {
      history = historyCached;
    } else {
      history = await homeAssistantRepository.getHistory(
          plant: plant,
          historyBodyDto: historyBodyDto,
          timeout: const Duration(seconds: 2),
          isConsumption: isConsumption);
    }
    return _getPlotInfo(history);
  }

  List<HistoryDto>? getHistoryCached(bool isConsumption) {
    if (isConsumption) {
      return appPreferencesInterface.getConsumptionInfo();
    }
    return appPreferencesInterface.getProductionInfo();
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
          (result) => result.spot,
        )
        .where((spot) => spot.y != double.negativeInfinity)
        .toList();
    return plot.sample(
        plot[0].x, plot[0].x + const Duration(days: 1).inMinutes, 10);
  }

  void onActive() {
    _active = true;
  }

  void onInactive() {
    _active = false;
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
    this.maxRange = Offset.zero,
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

class PhotovoltaicForecastInfo {
  final List<FlSpot> data;
  final Offset min;
  final Offset max;

  PhotovoltaicForecastInfo({
    this.data = const [],
    this.min = Offset.zero,
    this.max = Offset.zero,
  });

  PhotovoltaicForecastInfo copyWith({
    List<FlSpot>? data,
    Offset? min,
    Offset? max,
  }) =>
      PhotovoltaicForecastInfo(
        data: data ?? this.data,
        min: min ?? this.min,
        max: max ?? this.max,
      );
}
