import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/repository/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/main.dart';

part 'add_plant.event.dart';
part 'add_plant.state.dart';

class AddPlantBloc extends Bloc<AddPlantEvent, AddPlantState> {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  final HomeAssistantWebSocketRepository homeAssistantWebSocketRepository =
      HomeAssistantWebSocketRepository();

  AddPlantBloc() : super(const AddPlantState()) {
    on<RetrieveToken>(_onRetrieveToken);
  }

  @override
  void onTransition(Transition<AddPlantEvent, AddPlantState> transition) {
    super.onTransition(transition);
  }

  void _onRetrieveToken(RetrieveToken event, Emitter<AddPlantState> emit) {
    String? token = appPreferencesInterface.getToken()?.token;
    emit(state.copyWith(
      token: token,
    ));
  }
}
