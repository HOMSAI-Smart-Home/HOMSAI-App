part of 'add_sensor.bloc.dart';

class AddSensorState extends Equatable {
  const AddSensorState({
    this.productionSensors = const [],
    this.selectedProductionSensor,
    this.consumptionSensors = const [],
    this.selectedConsumptionSensor,
    this.photovoltaicNominalPower,
    this.photovoltaicInstallationDate,
    this.initialPhotovoltaicNominalPower,
    this.initialPhotovoltaicInstallationDate,
  });

  final List<MesurableSensorEntity> productionSensors;
  final MesurableSensorEntity? selectedProductionSensor;
  final List<MesurableSensorEntity> consumptionSensors;
  final MesurableSensorEntity? selectedConsumptionSensor;
  final String? photovoltaicNominalPower;
  final String? initialPhotovoltaicNominalPower;
  final DateTime? photovoltaicInstallationDate;
  final String? initialPhotovoltaicInstallationDate;

  AddSensorState copyWith({
    List<MesurableSensorEntity>? productionSensors,
    MesurableSensorEntity? selectedProductionSensor,
    List<MesurableSensorEntity>? consumptionSensors,
    MesurableSensorEntity? selectedConsumptionSensor,
    String? photovoltaicNominalPower,
    String? initialPhotovoltaicNominalPower,
    DateTime? photovoltaicInstallationDate,
    String? initialPhotovoltaicInstallationDate,
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
      initialPhotovoltaicNominalPower: initialPhotovoltaicNominalPower ??
          this.initialPhotovoltaicNominalPower,
      photovoltaicInstallationDate: photovoltaicInstallationDate,
      initialPhotovoltaicInstallationDate: initialPhotovoltaicInstallationDate,
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
        initialPhotovoltaicNominalPower ?? "",
        initialPhotovoltaicInstallationDate ?? "",
      ];
}
