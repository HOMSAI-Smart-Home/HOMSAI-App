import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/models/database/home_assistant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';

part 'home.event.dart';
part 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeAssistantWebSocketRepository webSocketRepository =
      getIt.get<HomeAssistantWebSocketRepository>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  HomeBloc() : super(const HomeState()) {
    on<ConnectWebSocket>(_onWebsocketConnect);
    on<FetchStates>(_onFetchState);
    on<FetchedLights>(_onFetchedLights);
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
  }

  void _onWebsocketConnect(
      ConnectWebSocket event, Emitter<HomeState> emit) async {
    HomeAssistantAuth? auth = appPreferencesInterface.getToken();
    if (!webSocketRepository.isConnected() && auth?.url != null) {
      webSocketRepository.connect(Uri.parse(auth!.url));
    }
  }

  void _onFetchState(FetchStates event, Emitter<HomeState> emit) {
    webSocketRepository.fetchingStates(
      WebSocketSubscriber((res) {
        add(FetchedLights(entities: res));
      }),
    );
  }

  void _onFetchedLights(FetchedLights event, Emitter<HomeState> emit) async {
    final plant = await appDatabase.plantDao.getActivePlant();
    final entities = await appDatabase.plantDao.getAllEntities(plant!.id!);
    List<LightEntity> lights;
    if (entities.isEmpty) {
      await appDatabase.homeAssitantDao
          .insertEntities(plant.id!, event.entities.getEntities<Entity>());

      lights = event.entities.getEntities<LightEntity>();
    } else {
      lights = entities.getEntities<LightEntity>();
    }

    emit(state.copyWith(lights: lights));
  }
}
