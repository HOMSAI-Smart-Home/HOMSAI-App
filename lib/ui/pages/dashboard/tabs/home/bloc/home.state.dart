part of 'home.bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.lights = const [],
    this.consumptionPlot,
    this.productionPlot,
    this.autoConsumption,
    this.optimizedConsumptionPlot,
    this.batteryPlot,
    this.chargePlot,
    this.optimizedBatteryPlot,
    this.balance,
    this.optimizedBalance,
    this.minOffset,
    this.maxOffset,
    this.isPlotOptimized = false,
    this.isLoading = true,
    this.alerts = const {},
    this.forecastData = const [],
    this.forecastMinOffset = Offset.zero,
    this.forecastMaxOffset = Offset.zero,
    this.activeGraphicChart,
  });

  final List<LightEntity> lights;
  final List<FlSpot>? consumptionPlot;
  final List<FlSpot>? productionPlot;
  final List<FlSpot>? batteryPlot;
  final List<FlSpot>? autoConsumption;
  final List<FlSpot>? chargePlot;
  final List<FlSpot>? optimizedConsumptionPlot;
  final List<FlSpot>? optimizedBatteryPlot;
  final PVBalanceDto? balance;
  final PVBalanceDto? optimizedBalance;
  final Offset? minOffset;
  final Offset? maxOffset;
  final bool isPlotOptimized;
  final bool isLoading;
  final Map<String, Widget> alerts;
  final List<FlSpot> forecastData;
  final Offset forecastMinOffset;
  final Offset forecastMaxOffset;
  final GraphicTypes? activeGraphicChart;

  HomeState copyWith({
    List<LightEntity>? lights,
    List<FlSpot>? consumptionPlot,
    List<FlSpot>? productionPlot,
    List<FlSpot>? batteryPlot,
    List<FlSpot>? autoConsumption,
    List<FlSpot>? chargePlot,
    List<FlSpot>? optimizedConsumptionPlot,
    List<FlSpot>? optimizedBatteryPlot,
    PVBalanceDto? balance,
    PVBalanceDto? optimizedBalance,
    Offset? minOffset,
    Offset? maxOffset,
    bool? isPlotOptimized,
    bool? isLoading,
    Map<String, Widget>? alerts,
    List<FlSpot>? forecastData,
    Offset? forecastMinOffset,
    Offset? forecastMaxOffset,
    GraphicTypes? activeGraphicChart,
  }) {
    return HomeState(
      lights: lights ?? this.lights,
      consumptionPlot: consumptionPlot ?? this.consumptionPlot,
      productionPlot: productionPlot ?? this.productionPlot,
      batteryPlot: batteryPlot ?? this.batteryPlot,
      autoConsumption: autoConsumption ?? this.autoConsumption,
      chargePlot: chargePlot ?? this.chargePlot,
      optimizedConsumptionPlot:
          optimizedConsumptionPlot ?? this.optimizedConsumptionPlot,
      optimizedBatteryPlot: optimizedBatteryPlot ?? this.optimizedBatteryPlot,
      balance: balance ?? this.balance,
      optimizedBalance: optimizedBalance ?? this.optimizedBalance,
      minOffset: minOffset ?? this.minOffset,
      maxOffset: maxOffset ?? this.maxOffset,
      isPlotOptimized: isPlotOptimized ?? this.isPlotOptimized,
      isLoading: isLoading ?? this.isLoading,
      alerts: alerts ?? this.alerts,
      forecastData: forecastData ?? this.forecastData,
      forecastMinOffset: forecastMinOffset ?? this.forecastMinOffset,
      forecastMaxOffset: forecastMaxOffset ?? this.forecastMaxOffset,
      activeGraphicChart: activeGraphicChart ?? this.activeGraphicChart,
    );
  }

  @override
  List<Object?> get props => [
        lights,
        consumptionPlot,
        productionPlot,
        batteryPlot,
        autoConsumption,
        chargePlot,
        optimizedConsumptionPlot,
        optimizedBatteryPlot,
        minOffset,
        maxOffset,
        isPlotOptimized,
        isLoading,
        alerts,
        forecastData,
        forecastMinOffset,
        forecastMaxOffset,
        activeGraphicChart,
      ];
}

enum GraphicStates { loading, error, photovoltaic, optimizedConsumption }
