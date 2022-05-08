import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/light/light.interface.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/main.dart';

part 'light_device.event.dart';
part 'light_device.state.dart';

class LightDeviceBloc extends Bloc<LightDeviceEvent, LightDeviceState> {
  final LightRepositoryInterface lightRepository =
      getIt.get<LightRepositoryInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  LightDeviceBloc(LightEntity light) : super(LightDeviceState(light: light)) {
    on<LightOn>(_onLightOn);
    on<LightOff>(_onLightOff);
    on<LightOnChanged>(_onChanged);
    on<LightNewState>(_onNewState);
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

  void _onChanged(LightOnChanged event, Emitter<LightDeviceState> emit) {
    lightRepository.onChanged(
        state.light, (entity) => add(LightNewState(entity)));
  }

  void _onNewState(LightNewState event, Emitter<LightDeviceState> emit) async {
    LightEntity light = event.light;
    final plant = await appDatabase.getPlant();
    if (plant != null) {
      await appDatabase.homeAssitantDao
          .updateItem(HomeAssistantEntity(plant.id!, light.id, light));
    }
    emit(state.copyWith(light: light));
  }
}
