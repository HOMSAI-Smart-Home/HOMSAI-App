part of 'home.bloc.dart';

class HomeState extends Equatable {
  const HomeState(
      {this.lights = const [],
      this.consumptionSensor,
      this.productionSensor,
      this.consumptionPlot,
      this.productionPlot,
      this.autoConsumption,
      this.optimizedConsumptionPlot,
      this.balance,
      this.optimizedBalance,
      this.minOffset,
      this.maxOffset,
      this.isPlotOptimized = false,
      this.isLoading = true,
      this.alerts = const []});

  final List<LightEntity> lights;

  final MesurableSensorEntity? consumptionSensor;
  final MesurableSensorEntity? productionSensor;
  final List<FlSpot>? consumptionPlot;
  final List<FlSpot>? productionPlot;
  final List<FlSpot>? autoConsumption;
  final List<FlSpot>? optimizedConsumptionPlot;
  final PVBalanceDto? balance;
  final PVBalanceDto? optimizedBalance;
  final Offset? minOffset;
  final Offset? maxOffset;
  final bool isPlotOptimized;
  final bool isLoading;
  final List<Widget> alerts;

  HomeState copyWith({
    List<LightEntity>? lights,
    MesurableSensorEntity? consumptionSensor,
    MesurableSensorEntity? productionSensor,
    List<FlSpot>? consumptionPlot,
    List<FlSpot>? productionPlot,
    List<FlSpot>? autoConsumption,
    List<FlSpot>? optimizedConsumptionPlot,
    PVBalanceDto? balance,
    PVBalanceDto? optimizedBalance,
    Offset? minOffset,
    Offset? maxOffset,
    bool? isPlotOptimized,
    bool? isLoading,
    Widget? alert,
    String? alertToRemove,
  }) {
    return HomeState(
      lights: lights ?? this.lights,
      consumptionSensor: consumptionSensor ?? this.consumptionSensor,
      productionSensor: productionSensor ?? this.productionSensor,
      consumptionPlot: consumptionPlot ?? this.consumptionPlot,
      productionPlot: productionPlot ?? this.productionPlot,
      autoConsumption: autoConsumption ?? this.autoConsumption,
      optimizedConsumptionPlot:
          optimizedConsumptionPlot ?? this.optimizedConsumptionPlot,
      balance: balance ?? this.balance,
      optimizedBalance: optimizedBalance ?? this.optimizedBalance,
      minOffset: minOffset ?? this.minOffset,
      maxOffset: maxOffset ?? this.maxOffset,
      isPlotOptimized: isPlotOptimized ?? this.isPlotOptimized,
      isLoading: isLoading ?? this.isLoading,
      alerts: checkAlerts(alert, alertToRemove, alerts),
    );
  }

  @override
  List<Object?> get props => [
        lights,
        consumptionSensor,
        productionSensor,
        consumptionPlot,
        productionPlot,
        autoConsumption,
        optimizedConsumptionPlot,
        minOffset,
        maxOffset,
        isPlotOptimized,
        isLoading,
        alerts
      ];
}

List<Widget> checkAlerts(
    Widget? alert, String? alertToRemove, List<Widget> alerts) {
  if (alert != null &&
      alerts.where((element) => element.key == alert.key).isEmpty) {
    return alerts + [alert];
  }

  if (alertToRemove != null && alerts.isNotEmpty) {
    var newAlerts = List<Widget>.from(alerts);
    newAlerts.removeWhere((element) => element.key == Key(alertToRemove));
    return newAlerts;
  }

  return alerts;
}
