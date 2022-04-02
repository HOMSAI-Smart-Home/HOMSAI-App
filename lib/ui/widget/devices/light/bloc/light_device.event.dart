part of 'light_device.bloc.dart';

abstract class LightDeviceEvent extends Equatable {
  const LightDeviceEvent();

  @override
  List<Object> get props => [];
}

class LightOn extends LightDeviceEvent {}

class LightOff extends LightDeviceEvent {}
