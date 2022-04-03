import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/light/light.interface.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/main.dart';

part 'light_device.event.dart';
part 'light_device.state.dart';

class LightDeviceBloc extends Bloc<LightDeviceEvent, LightDeviceState> {
  final LightRepositoryInterface lightRepository =
      getIt.get<LightRepositoryInterface>();

  LightDeviceBloc(LightEntity light) : super(LightDeviceState(light: light)) {
    on<LightOn>(_onLightOn);
    on<LightOff>(_onLightOff);
  }

  @override
  void onTransition(Transition<LightDeviceEvent, LightDeviceState> transition) {
    super.onTransition(transition);
  }

  void _onLightOn(LightOn event, Emitter<LightDeviceState> emit) {
    LightEntity light = event.light;
    lightRepository.turnOn(light);
    emit(state.copyWith(light: light));
  }

  void _onLightOff(LightOff event, Emitter<LightDeviceState> emit) {
    LightEntity light = event.light;
    lightRepository.turnOff(light);
    emit(state.copyWith(light: light));
  }
}
