part of 'add_sensor.bloc.dart';

class AddSensorState extends Equatable {
  const AddSensorState({
    this.productionSensors = const [],
    this.selectedProductionSensor,
    this.consumptionSensors = const [],
    this.selectedConsumptionSensor,
  });

  final List<MesurableSensorEntity> productionSensors;
  final MesurableSensorEntity? selectedProductionSensor;
  final List<MesurableSensorEntity> consumptionSensors;
  final MesurableSensorEntity? selectedConsumptionSensor;

  AddSensorState copyWith({
    List<MesurableSensorEntity>? productionSensors,
    MesurableSensorEntity? selectedProductionSensor,
    List<MesurableSensorEntity>? consumptionSensors,
    MesurableSensorEntity? selectedConsumptionSensor,
  }) {
    return AddSensorState(
      productionSensors: productionSensors ?? this.productionSensors,
      selectedProductionSensor:
          selectedProductionSensor ?? this.selectedProductionSensor,
      consumptionSensors: consumptionSensors ?? this.consumptionSensors,
      selectedConsumptionSensor:
          selectedConsumptionSensor ?? this.selectedConsumptionSensor,
    );
  }

  @override
  List<Object> get props => [
        productionSensors,
        selectedProductionSensor?.id ?? "",
        consumptionSensors,
        selectedConsumptionSensor?.id ?? ""
      ];
}
