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
import 'package:homsai/crossconcern/exceptions/url.exception.dart';
import 'package:homsai/crossconcern/components/charts/photovoltaic_forecast_chart.widget.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/crossconcern/utilities/properties/connection.properties.dart';
import 'package:homsai/crossconcern/utilities/properties/constants.util.dart';
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
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/main.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:timezone/timezone.dart';

part 'home.event.dart';
part 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NetworkManagerInterface _networkManagerInterface =
      getIt.get<NetworkManagerInterface>();

  final AIServiceInterface aiServiceInterface = getIt.get<AIServiceInterface>();

  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final HomsaiDatabase appDatabase = getIt.get<HomsaiDatabase>();

  bool _active = true;
  final WebSocketBloc _webSocketBloc;

  HomeBloc(this._webSocketBloc) : super(const HomeState()) {
    on<FetchStates>(_onFetchState);
    on<FetchedLights>(_onFetchedLights);
    on<FetchHistory>(_onFetchHistory);
    on<FetchPhotovoltaicForecast>(_onFetchPhotovoltaicForecast);
    on<ToggleConsumptionOptimazedPlot>(_onToggleConsumptionOptimazedPlot);
    on<FetchSuggestionsChart>(_onFetchSuggestionsChart);
    on<AddAlert>(_onAddAlert);
    on<RemoveAlert>(_onRemoveAlert);

    _networkManagerInterface.subscribe(NetworkManagerSubscriber(
      (result) => {_checkConnection(result)},
    ));
    _webSocketBloc.subscribeToExeption(
      UrlException,
      () => add(const AddAlert(
          NoHomeAssistantConnectionAlert(
            key: Key(ConnectionProperties.noHomeAssistantConnectionAlertKey),
          ),
          ConnectionProperties.noHomeAssistantConnectionAlertKey)),
    );
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

  void _onFetchState(FetchStates event, Emitter<HomeState> emit) {
    _webSocketBloc.add(FetchEntities(
      onEntitiesFetched: (entities) {
        if (_active) add(FetchedLights(entities: entities));
      },
    ));
  }

  void _onAddAlert(AddAlert event, Emitter<HomeState> emit) {
    final Map<String, Widget> alerts = Map.from(state.alerts);
    alerts.putIfAbsent(event.alertId, () => event.alert);
    emit(state.copyWith(alerts: alerts));
  }

  void _onRemoveAlert(RemoveAlert event, Emitter<HomeState> emit) {
    final Map<String, Widget> alerts = Map.from(state.alerts);
    alerts.remove(event.alertId);
    emit(state.copyWith(alerts: alerts));
  }

  Future<void> _onFetchedLights(
      FetchedLights event, Emitter<HomeState> emit) async {
    final plant = await appDatabase.getPlant();
    if (plant != null && plant.id != null) {
      await appDatabase.homeAssitantDao.refreshPlantEntities(
          plant.id!, event.entities.getEntities<Entity>());
    }
    if (_active) {
      LogbookDto logBook;
      DailyPlanBodyDto dailyPlanBodyDto;
      DailyPlanDto dailyPlan;
      final dailyPlanCached = appPreferencesInterface.getDailyPlan();

      if (dailyPlanCached != null &&
          _checkIfDateIsSameDay(dailyPlanCached.dateFetched)) {
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
      final orderedDevices = orderDevicesByDailyPlan(dailyPlan, lights);
      emit(state.copyWith(lights: orderedDevices));
    }
  }

  @visibleForTesting
  List<LightEntity> orderDevicesByDailyPlan(
    DailyPlanDto dailyPlan,
    List<LightEntity> lights,
  ) {
    final currentHour = TZDateTime.now(getIt.get<Location>()).hour;
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
    final autoConsumption = _checkAutoConsumption(
      isOptimized: event.isOptimized,
      optimizedConsumption:
          PlotInfo(plot: state.optimizedConsumptionPlot ?? []),
      optimizedBattery: PlotInfo(plot: state.optimizedBatteryPlot ?? []),
      productionPlot: state.productionPlot!,
      consumptionPlot: state.consumptionPlot!,
      batteryPlot: state.batteryPlot!,
    );
    emit(state.copyWith(
      autoConsumption: autoConsumption,
      chargePlot: _checkCharge(
        isOptimized: event.isOptimized,
        autoConsumption: autoConsumption,
        batteryPlot: state.batteryPlot ?? [],
        optimizedBatteryPlot:
            state.optimizedBatteryPlot ?? DailyConsumptionChart.emptyPlot,
      ),
      isPlotOptimized: event.isOptimized,
    ));
  }

  List<FlSpot> _checkAutoConsumption({
    required bool isOptimized,
    required PlotInfo optimizedConsumption,
    PlotInfo? optimizedBattery,
    required List<FlSpot> productionPlot,
    required List<FlSpot> consumptionPlot,
    required List<FlSpot> batteryPlot,
  }) {
    if (isOptimized) {
      final autoConsumption =
          optimizedConsumption.plot.intersect(productionPlot);
      return optimizedBattery == null
          ? autoConsumption
          : autoConsumption
              .sample(
                autoConsumption[0].x,
                autoConsumption[0].x + const Duration(days: 1).inMinutes,
                10,
              )
              .stack(optimizedBattery.plot.sample(
                optimizedBattery.plot[0].x,
                optimizedBattery.plot[0].x + const Duration(days: 1).inMinutes,
                10,
              ));
    }

    var autoConsumption = consumptionPlot.intersect(productionPlot);
    autoConsumption.sample(
      autoConsumption[0].x,
      autoConsumption[0].x + const Duration(days: 1).inMinutes,
      10,
    );
    if (batteryPlot.isNotEmpty) {
      autoConsumption = autoConsumption.stack(batteryPlot.sample(
        batteryPlot[0].x,
        batteryPlot[0].x + const Duration(days: 1).inMinutes,
        10,
      ));
    }

    return autoConsumption;
  }

  List<FlSpot> _checkCharge({
    required bool isOptimized,
    required List<FlSpot> autoConsumption,
    required List<FlSpot> optimizedBatteryPlot,
    required List<FlSpot> batteryPlot,
  }) {
    if (isOptimized) {
      return optimizedBatteryPlot
          .map((flSpot) => FlSpot(
                flSpot.x,
                min(flSpot.y, 0) * -1,
              ))
          .toList()
          .sample(
            optimizedBatteryPlot[0].x,
            optimizedBatteryPlot[0].x + const Duration(days: 1).inMinutes,
            10,
          )
          .stack(autoConsumption);
    } else {
      final battery = batteryPlot
          .map((flSpot) => FlSpot(
                flSpot.x,
                min(flSpot.y, 0) * -1,
              ))
          .toList();
      if (batteryPlot.isNotEmpty) {
        battery.sample(
          batteryPlot[0].x,
          batteryPlot[0].x + const Duration(days: 1).inMinutes,
          10,
        );
      }
      return battery.stack(autoConsumption);
    }
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

  bool _checkIfDateIsSameDay(DateTime date) {
    // Check if the forecast date is today
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    return date.isAtSameMomentAs(today);
  }

  void _onFetchSuggestionsChart(
    FetchSuggestionsChart event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      Plant? plant = await appDatabase.getPlant();
      if (plant != null) {
        GraphicTypes? chartType;
        if (plant.canShowConsumptionOptimization) {
          chartType = GraphicTypes.consumptionOptimizations;
        }
        if (plant.canShowPhotovoltaicForecast) {
          chartType = GraphicTypes.pvForecast;
        }
        if (plant.canShowConsumptionOptimization &&
            plant.canShowPhotovoltaicForecast) {
          final suggestionsChartResult =
              await aiServiceInterface.getSuggestionsChart();
          chartType = mapSuggestionsChart[suggestionsChartResult.chart];
        }

        switch (chartType) {
          case GraphicTypes.pvForecast:
            add(FetchPhotovoltaicForecast());
            break;
          default:
            add(FetchHistory());
            break;
        }
        emit(state.copyWith(activeGraphicChart: chartType));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onFetchHistory(FetchHistory event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final plant = await appDatabase.getPlant();

    if (plant != null) {
      try {
        Configuration? configuration = await appDatabase.getConfiguration();

        final consumptionInfo = await _getConsumptionInfo(
          plant.consumptionSensor,
          plant,
        );

        final productionInfo = await _getProductionInfo(
          plant.productionSensor,
          plant,
        );

        final batteryInfo = await _getBatteryInfo(
          plant.batterySensor,
          plant,
        );

        final productionSensor = await appDatabase.homeAssitantDao
            .findEntity<MesurableSensorEntity>(
                plant.id!, plant.productionSensor!);
        final consumptionSensor = await appDatabase.homeAssitantDao
            .findEntity<MesurableSensorEntity>(
                plant.id!, plant.consumptionSensor!);

        List<FlSpot> autoConsumption = [];
        List<FlSpot> charge = [];
        ConsumptionOptimizationsForecastDto? consumptionForecast;
        PlotInfo? optimizedConsumptionInfo;
        PlotInfo? optimizedBatteryInfo;

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
                      batteryMeterData: batteryInfo.history.isNotEmpty
                          ? batteryInfo.history
                          : null,
                    ),
                    configuration!.unitSystemType);
            appPreferencesInterface
                .setOptimizationForecast(consumptionForecast);
          }

          optimizedConsumptionInfo =
              _getPlotInfo(consumptionForecast.optimizedGeneralPowerMeterData);
          optimizedBatteryInfo =
              consumptionForecast.optimizedBatteryData != null
                  ? _getPlotInfo(consumptionForecast.optimizedBatteryData!)
                  : null;

          autoConsumption = _checkAutoConsumption(
            isOptimized: state.isPlotOptimized,
            optimizedConsumption: optimizedConsumptionInfo,
            consumptionPlot: consumptionInfo.plot,
            productionPlot: productionInfo.plot,
            batteryPlot: batteryInfo.plot,
            optimizedBattery: optimizedBatteryInfo,
          );

          charge = _checkCharge(
            autoConsumption: autoConsumption,
            batteryPlot: batteryInfo.plot,
            isOptimized: state.isPlotOptimized,
            optimizedBatteryPlot:
                optimizedBatteryInfo?.plot ?? DailyConsumptionChart.emptyPlot,
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
              batteryPlot: batteryInfo.plot.isNotEmpty
                  ? batteryInfo.plot
                  : DailyConsumptionChart.emptyPlot,
              optimizedConsumptionPlot: optimizedConsumptionInfo?.plot ??
                  DailyConsumptionChart.emptyPlot,
              optimizedBatteryPlot:
                  optimizedBatteryInfo?.plot ?? DailyConsumptionChart.emptyPlot,
              autoConsumption: autoConsumption,
              chargePlot:
                  charge.isNotEmpty ? charge : DailyConsumptionChart.emptyPlot,
              balance: consumptionForecast?.withoutHomsai,
              optimizedBalance: consumptionForecast?.withHomsai,
              minOffset: minOffset(
                consumptionInfo.minRange,
                productionInfo.minRange,
                optimizedConsumptionInfo?.minRange,
              ),
              maxOffset: maxOffset(
                consumptionInfo.maxRange,
                productionInfo.maxRange,
                optimizedConsumptionInfo?.maxRange,
              ),
              isLoading: false));
        } else {
          emit(state.copyWith(lights: state.lights, isLoading: false));
        }
      } catch (e) {
        emit(HomeState(lights: state.lights, isLoading: false));
      }
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onFetchPhotovoltaicForecast(
      FetchPhotovoltaicForecast event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoading: true));
    final plant = await appDatabase.getPlant();
    if (plant != null &&
        plant.photovoltaicNominalPower != null &&
        plant.photovoltaicInstallationDate != null) {
      try {
        final photovoltaicForecast = await _getPhotovoltaicForecast(
          plant.photovoltaicNominalPower!,
          plant.photovoltaicInstallationDate!.difference(DateTime.now()).inDays,
          plant.latitude,
          plant.longitude,
        );
        emit(state.copyWith(
          forecastData: photovoltaicForecast.data,
          forecastMinOffset: photovoltaicForecast.min,
          forecastMaxOffset: photovoltaicForecast.max,
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    } else {
      emit(state.copyWith(isLoading: false));
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
        photovoltaicForecast.map((element) => element.toSpot).where((spot) {
      final spotTime = PhotovoltaicForecastChart.getDateTimeFromSpot(spot);
      return spotTime
              .isAfter(DateTime.now().subtract(const Duration(hours: 3))) &&
          spotTime.isBefore(DateTime.now().add(const Duration(hours: 27)));
    }).toList();

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

  Future<PlotInfo> _getConsumptionInfo(
    String? sensor,
    Plant plant,
  ) async {
    if (sensor == null) return PlotInfo();

    List<HistoryDto> history = await _getHistoryFromSensor(
      appPreferencesInterface.getConsumptionInfo(),
      sensor,
      plant,
    );

    appPreferencesInterface.setConsumptionInfo(history);
    return _getPlotInfo(history);
  }

  Future<PlotInfo> _getProductionInfo(
    String? sensor,
    Plant plant,
  ) async {
    if (sensor == null) return PlotInfo();

    List<HistoryDto> history = await _getHistoryFromSensor(
      appPreferencesInterface.getProductionInfo(),
      sensor,
      plant,
    );

    appPreferencesInterface.setProductionInfo(history);
    return _getPlotInfo(history);
  }

  Future<PlotInfo> _getBatteryInfo(
    String? sensor,
    Plant plant,
  ) async {
    if (sensor == null) return PlotInfo();

    List<HistoryDto> history = await _getHistoryFromSensor(
      appPreferencesInterface.getBatteryInfo(),
      sensor,
      plant,
    );

    appPreferencesInterface.setBatteryInfo(history);
    return _getPlotInfo(history);
  }

  Future<List<HistoryDto>> _getHistoryFromSensor(
    List<HistoryDto>? history,
    String sensor,
    Plant plant,
  ) async {
    if (history != null &&
        history.isNotEmpty &&
        _checkIfDateIsYesterday(history[0].lastChanged)) {
      return history;
    }

    history = await homeAssistantRepository.getHistory(
      plant: plant,
      historyBodyDto: HistoryBodyDto(
        sensor,
        minimalResponse: true,
      ),
      timeout: const Duration(seconds: 2),
    );

    return history;
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
