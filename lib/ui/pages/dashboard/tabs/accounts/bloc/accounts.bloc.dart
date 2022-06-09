import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';

part 'accounts.event.dart';
part 'accounts.state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsState? initialState;
  final HomsaiDatabase _appDatabase = getIt.get<HomsaiDatabase>();
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();
  final HomeAssistantWebSocketInterface websocket =
      getIt.get<HomeAssistantWebSocketInterface>();

  AccountsBloc() : super(const AccountsState()) {
    on<Autocomplete>(_onAutocomplete);
    on<Update>(_onUpdate);
    on<WebsocketUpdate>(_onWebsocketUpdate);
    on<SensorUpdate>(_onSensorUpdate);
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
    SensorEntity? batterySensor;

    final plant = await _appDatabase.getPlant();

    if (plant == null) return;

    if (plant.consumptionSensor != null) {
      consumptionSensor =
          await _appDatabase.getEntity<SensorEntity>(plant.consumptionSensor!);
    }
    if (plant.productionSensor != null) {
      productionSensor =
          await _appDatabase.getEntity<SensorEntity>(plant.productionSensor!);
    }
    if (plant.batterySensor != null) {
      batterySensor =
          await _appDatabase.getEntity<SensorEntity>(plant.batterySensor!);
    }

    final user = await _appDatabase.getUser();

    if (user == null) return;

    final newState = state.copyWith(
      localUrl: plant.localUrl ?? '',
      remoteUrl: plant.remoteUrl ?? '',
      consumptionSensor: consumptionSensor?.name,
      productionSensor: productionSensor?.name,
      batterySensor: batterySensor?.name,
      photovoltaicNominalPower:
          plant.photovoltaicNominalPower?.toString() ?? '',
      photovoltaicInstallationDate:
          '${plant.photovoltaicInstallationDate?.month ?? '-'}/${plant.photovoltaicInstallationDate?.year ?? '-'}',
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

  Future<void> _onWebsocketUpdate(
      WebsocketUpdate event, Emitter<AccountsState> emit) async {
    if (initialState == null) return;
    await _onAutocomplete(Autocomplete(), emit);

    if (initialState!.localUrl != state.localUrl ||
        initialState!.remoteUrl != state.remoteUrl) {
      await _restartWebsocket();
      initialState = state;
    }
  }

  Future<void> _onSensorUpdate(
      SensorUpdate event, Emitter<AccountsState> emit) async {
    if (initialState == null) return;
    await _onAutocomplete(Autocomplete(), emit);
    if (initialState!.consumptionSensor != state.consumptionSensor ||
        initialState!.productionSensor != state.productionSensor ||
        initialState!.batterySensor != state.batterySensor) {
      _resetPlot();
    }
  }

  Future<void> _restartWebsocket() {
    return websocket.reconnect();
  }

  void _resetPlot() {
    appPreferences.resetConsumptionInfo();
    appPreferences.resetOptimizationForecast();
    appPreferences.resetProductionInfo();
    appPreferences.resetBatteryInfo();
  }
}
