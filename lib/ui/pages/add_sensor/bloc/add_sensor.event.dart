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

class OnSubmit extends AddSensorEvent {
  const OnSubmit(this.onSubmit);

  final void Function() onSubmit;

  @override
  List<Object> get props => [onSubmit];
}
