part of 'light_device.bloc.dart';

abstract class LightDeviceEvent extends Equatable {
  const LightDeviceEvent();

  @override
  List<Object> get props => [];
}

class LightOn extends LightDeviceEvent {
  const LightOn(this._lightEntity);

  final LightEntity _lightEntity;
  LightEntity get light => _lightEntity.copy();

  @override
  List<Object> get props => [light];
}

class LightOff extends LightDeviceEvent {
  const LightOff(this._lightEntity);

  final LightEntity _lightEntity;
  LightEntity get light => _lightEntity.copy();

  @override
  List<Object> get props => [light];
}
