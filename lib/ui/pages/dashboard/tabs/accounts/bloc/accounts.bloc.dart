import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';

part 'accounts.event.dart';
part 'accounts.state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsState? initialState;
  final AppDatabase appDatabase = getIt.get<AppDatabase>();
  final HomeAssistantWebSocketInterface websocket =
      getIt.get<HomeAssistantWebSocketInterface>();

  AccountsBloc() : super(const AccountsState()) {
    on<Autocomplete>(_onAutocomplete);
    on<Update>(_onUpdate);
    on<Exit>(_onExit);
    add(Autocomplete());
  }

  @override
  void onTransition(Transition<AccountsEvent, AccountsState> transition) {
    super.onTransition(transition);
  }

  Future<void> _onAutocomplete(
    Autocomplete event,
    Emitter<AccountsState> emit,
  ) async {
    SensorEntity? consumptionSensor;
    SensorEntity? productionSensor;
    final plant = await appDatabase.getPlant();
    if (plant == null) return;

    if (plant.consumptionSensor != null) {
      consumptionSensor =
          await appDatabase.getEntity<SensorEntity>(plant.consumptionSensor!);
    }
    if (plant.productionSensor != null) {
      productionSensor =
          await appDatabase.getEntity<SensorEntity>(plant.productionSensor!);
    }

    final user = await appDatabase.getUser();

    if (user == null) return;

    final newState = state.copyWith(
      localUrl: plant.localUrl ?? '',
      remoteUrl: plant.remoteUrl ?? '',
      consumptionSensor: consumptionSensor?.name,
      productionSensor: productionSensor?.name,
      plantName: plant.name,
      position: (plant.latitude).toStringAsFixed(5) +
          ', ' +
          (plant.longitude).toStringAsFixed(5),
      email: user.email,
      version: appVersion,
    );

    initialState ??= newState;

    emit(newState);
  }

  void _onUpdate(Update event, Emitter<AccountsState> emit) {
    add(Autocomplete());
  }

  void _onExit(Exit event, Emitter<AccountsState> emit) {
    if (initialState == null) return;

    if (initialState!.localUrl != state.localUrl ||
        initialState!.remoteUrl != state.remoteUrl) {
      _restartWebsocket();
    }
    if (initialState!.consumptionSensor != state.consumptionSensor ||
        initialState!.productionSensor != state.productionSensor) {
      _resetPlot();
    }
  }

  void _restartWebsocket() {
    websocket.reconnect();
  }

  void _resetPlot() {}
}
