import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/business/repository/home_assistant_websocket.repository.dart';
import 'package:homsai/business/repository/light.repository.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/entity.entity.model.dart';
import 'package:homsai/datastore/models/entity/light.entity.model.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';

part 'home.event.dart';
part 'home.state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeAssistantWebSocketRepository webSocketRepository =
      getIt.get<HomeAssistantWebSocketRepository>();

  final LightRepository lightRepository = getIt.get<LightRepository>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  HomeBloc() : super(const HomeState()) {
    on<ConnectWebSocket>(_onWebsocketConnect);
    on<FetchStates>(_onFetchState);
    on<FetchedLights>(_onFetchedLights);
    on<LightOn>(_onLightOn);
    on<LightOff>(_onLightOff);
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
  }

  void _onWebsocketConnect(
      ConnectWebSocket event, Emitter<HomeState> emit) async {
    HomeAssistantAuth? auth = appPreferencesInterface.getToken();
    if (auth?.url != null) {
      webSocketRepository.connect(Uri.parse(auth!.url!));
    }
    /*
    emit(state.copyWith(lights: [
      LightEntity.fromJson({
        "entity_id": "light.lampadina-test",
        "state": "off",
        "attributes": {"friendly_name": "lampadina test"},
        "context": {'id': '123456'}
      })
    ]));
    */
  }

  void _onFetchState(FetchStates event, Emitter<HomeState> emit) {
    webSocketRepository.fetchingStates(
      Subscriber((res) {
        add(FetchedLights(entities: res));
      }),
    );
  }

  void _onFetchedLights(FetchedLights event, Emitter<HomeState> emit) {
    List<LightEntity> lights = event.entities
        .map((entity) {
          if ((entity["entity_id"] as String).contains("light.")) {
            return LightEntity.fromJson(entity);
          }
          return null;
        })
        .where((element) => element != null)
        .map<LightEntity>((e) => e!)
        .toList();

    emit(state.copyWith(lights: lights));
  }

  void _onLightOn(LightOn event, Emitter<HomeState> emit) async {
    List<LightEntity> lights = List<LightEntity>.from(state.lights);
    lightRepository.turnOn(event.light);
    int index = lights.indexWhere((light) => event.light.id == light.id);
    lights.replaceRange(index, index + 1, [event.light]);
    emit(state.copyWith(lights: lights));
  }

  void _onLightOff(LightOff event, Emitter<HomeState> emit) async {
    List<LightEntity> lights = List<LightEntity>.from(state.lights);
    lightRepository.turnOff(event.light);
    int index = lights.indexWhere((light) => event.light.id == light.id);
    lights.replaceRange(index, index + 1, [event.light]);
    emit(state.copyWith(lights: lights));
  }
}
