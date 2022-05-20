part of 'add_sensor.bloc.dart';

abstract class AddSensorEvent extends Equatable {
  const AddSensorEvent();

  @override
  List<Object> get props => [];
}

class RetrieveSensors extends AddSensorEvent {}

class ProductionSensorChanged extends AddSensorEvent {
  const ProductionSensorChanged(this._sensor);

  final MesurableSensorEntity? _sensor;

  MesurableSensorEntity? get sensor => _sensor?.copy();
}

class ConsumptionSensorChanged extends AddSensorEvent {
  const ConsumptionSensorChanged(this._sensor);

  final MesurableSensorEntity? _sensor;

  MesurableSensorEntity? get sensor => _sensor?.copy();
}

class PhotovoltaicNominalPowerChanged extends AddSensorEvent {
  const PhotovoltaicNominalPowerChanged(this.value);

  final String value;

  @override
  List<Object> get props => [value];
}

class PhotovoltaicInstallatioDateChanged extends AddSensorEvent {
  const PhotovoltaicInstallatioDateChanged(this.date);

  final String date;

  @override
  List<Object> get props => [date];
}

class OnSubmit extends AddSensorEvent {
  const OnSubmit(this.onSubmit);

  final void Function() onSubmit;

  @override
  List<Object> get props => [onSubmit];
}
class EntitiesFetched extends AddSensorEvent {
  const EntitiesFetched(this.entities);

  final List<Entity> entities;

  @override
  List<Object> get props => [entities];
}
