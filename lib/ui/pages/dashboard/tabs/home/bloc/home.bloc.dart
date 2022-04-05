import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  void _onFetchedLights(FetchedLights event, Emitter<HomeState> emit) {
    List<LightEntity> lights = event.entities
        .map((entity) {
          if (Entity.fromJson(entity).entityId.contains("light.")) {
            return LightEntity.fromJson(entity);
          }
          return null;
        })
        .where((entity) => entity != null)
        .map<LightEntity>((light) => light!)
        .toList();

    emit(state.copyWith(lights: lights));
  }
}
