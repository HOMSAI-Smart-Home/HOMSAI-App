import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
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
      Autocomplete event, Emitter<AccountsState> emit) async {
    final plant = await appDatabase.getPlant();
    final user = await appDatabase.getUser();

    emit(
      state.copyWith(
        localUrl: plant?.localUrl,
        remoteUrl: plant?.remoteUrl,
        consumptionSensor: plant?.consumptionSensor,
        productionSensor: plant?.productionSensor,
        plantName: plant?.name,
        position: (plant != null ? plant.latitude : 0).toStringAsFixed(5) +
            ', ' +
            (plant != null ? plant.longitude : 0).toStringAsFixed(5),
        email: user?.email,
        version: appVersion,
      ),
    );
  }

  void _onUpdate(Update event, Emitter<AccountsState> emit) {
    add(Autocomplete());
  }
}
