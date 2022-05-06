import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:homsai/main.dart';

part 'accounts.event.dart';
part 'accounts.state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  AccountsBloc() : super(const AccountsState()) {
    on<Autocomplete>(_onAutocomplete);
    on<Update>(_onUpdate);
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

    emit(
      state.copyWith(
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
      ),
    );
  }

  void _onUpdate(Update event, Emitter<AccountsState> emit) {
    add(Autocomplete());
  }
}
