import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';

part 'dashboard.event.dart';
part 'dashboard.state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final AppDatabase _appDatabase = getIt.get<AppDatabase>();
  final HomeAssistantInterface _homeAssistantInterface =
      getIt.get<HomeAssistantInterface>();
  final HomeAssistantWebSocketInterface _homeAssistantWebSocketInterface =
      getIt.get<HomeAssistantWebSocketInterface>();

  DashboardBloc() : super(const DashboardState()) {
    on<RetrievePlantName>(_onRetrievePlantName);
    on<Logout>(_onLogout);
    add(RetrievePlantName());
  }

  @override
  void onTransition(Transition<DashboardEvent, DashboardState> transition) {
    super.onTransition(transition);
  }

  void _onRetrievePlantName(
      RetrievePlantName event, Emitter<DashboardState> emit) async {
    final plant = await _appDatabase.getPlant();
    emit(state.copyWith(plantName: plant?.name));
  }

  void _onLogout(Logout event, Emitter<DashboardState> emit) async {
    await _homeAssistantWebSocketInterface.logout();

    //TODO:fix when websocket factory
    Plant plant = (await _appDatabase.getPlant())!;
    try {
      await _homeAssistantInterface.revokeToken(plant: plant);
      print('removed');
    } catch (_) {
      print('not removed');
    }
    
    _homeAssistantInterface.getLogBook(plant: plant);

    await _appDatabase.logout();
    event.onLogout();
  }
}
