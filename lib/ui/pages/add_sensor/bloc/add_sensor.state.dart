part of 'add_sensor.bloc.dart';

class AddSensorState extends Equatable {
  const AddSensorState({
    this.productionSensors = const [],
    this.selectedProductionSensor,
    this.consumptionSensors = const [],
    this.selectedConsumptionSensor,
    this.photovoltaicNominalPower,
    this.photovoltaicInstallationDate,
  });

  final List<MesurableSensorEntity> productionSensors;
  final MesurableSensorEntity? selectedProductionSensor;
  final List<MesurableSensorEntity> consumptionSensors;
  final MesurableSensorEntity? selectedConsumptionSensor;
  final String? photovoltaicNominalPower;
  final DateTime? photovoltaicInstallationDate;

  AddSensorState copyWith({
    List<MesurableSensorEntity>? productionSensors,
    MesurableSensorEntity? selectedProductionSensor,
    List<MesurableSensorEntity>? consumptionSensors,
    MesurableSensorEntity? selectedConsumptionSensor,
    String? photovoltaicNominalPower,
    DateTime? photovoltaicInstallationDate,
  }) {
    return AddSensorState(
      productionSensors: productionSensors ?? this.productionSensors,
      selectedProductionSensor:
          selectedProductionSensor ?? this.selectedProductionSensor,
      consumptionSensors: consumptionSensors ?? this.consumptionSensors,
      selectedConsumptionSensor:
          selectedConsumptionSensor ?? this.selectedConsumptionSensor,
      photovoltaicNominalPower:
          photovoltaicNominalPower ?? this.photovoltaicNominalPower,
      photovoltaicInstallationDate: photovoltaicInstallationDate,
    );
  }

  @override
  List<Object> get props => [
        productionSensors,
        selectedProductionSensor?.id ?? "",
        consumptionSensors,
        selectedConsumptionSensor?.id ?? "",
        photovoltaicNominalPower ?? "",
        photovoltaicInstallationDate ??
            DateTime(
              DateTime.now().year,
              DateTime.now().month,
            ),
      ];
}
