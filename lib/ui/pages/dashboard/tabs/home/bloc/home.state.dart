part of 'home.bloc.dart';

class HomeState extends Equatable {
  const HomeState({
    this.lights = const [],
    this.consumptionPlot,
    this.productionPlot,
    this.autoConsumption,
    this.autoConsumptionOptimization,
    this.minOffset,
    this.maxOffset,
    this.isPlotOptimized = false,
  });

  final List<LightEntity> lights;
  final List<FlSpot>? consumptionPlot;
  final List<FlSpot>? productionPlot;
  final List<FlSpot>? autoConsumption;
  final List<FlSpot>? autoConsumptionOptimization;
  final Offset? minOffset;
  final Offset? maxOffset;
  final bool isPlotOptimized;

  HomeState copyWith({
    List<LightEntity>? lights,
    List<FlSpot>? consumptionPlot,
    List<FlSpot>? productionPlot,
    List<FlSpot>? autoConsumption,
    List<FlSpot>? autoConsumptionOptimization,
    Offset? minOffset,
    Offset? maxOffset,
    bool? isPlotOptimized,
  }) {
    return HomeState(
      lights: lights ?? this.lights,
      consumptionPlot: consumptionPlot ?? this.consumptionPlot,
      productionPlot: productionPlot ?? this.productionPlot,
      autoConsumption: autoConsumption ?? this.autoConsumption,
      autoConsumptionOptimization:
          autoConsumptionOptimization ?? this.autoConsumptionOptimization,
      minOffset: minOffset ?? this.minOffset,
      maxOffset: maxOffset ?? this.maxOffset,
      isPlotOptimized: isPlotOptimized ?? this.isPlotOptimized,
    );
  }

  @override
  List<Object?> get props => [
        lights,
        consumptionPlot,
        productionPlot,
        autoConsumption,
        autoConsumptionOptimization,
        minOffset,
        maxOffset,
        isPlotOptimized,
      ];
}
