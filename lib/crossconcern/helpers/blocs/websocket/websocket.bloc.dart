import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/main.dart';

part 'websocket.event.dart';
part 'websocket.state.dart';

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final HomeAssistantWebSocketInterface webSocketRepository =
      getIt.get<HomeAssistantWebSocketInterface>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  WebSocketBloc() : super(const WebSocketState()) {
    on<ConnectWebSocket>(_onWebsocketConnect);
    on<FetchConfig>(_onFetchConfig);
    on<FetchEntites>(_onFetchEntities);
  }

  @override
  void onTransition(Transition<WebSocketEvent, WebSocketState> transition) {
    super.onTransition(transition);
  }

  void _onWebsocketConnect(
      ConnectWebSocket event, Emitter<WebSocketState> emit) async {
    if (event.url.isNotEmpty) {
      return await webSocketRepository.connect(
        url: Uri.parse(event.url),
        onConnected: event.onWebSocketConnected,
      );
    }
    await webSocketRepository.connect(onConnected: event.onWebSocketConnected);
  }

  void _onFetchConfig(FetchConfig event, Emitter<WebSocketState> emit) {
    webSocketRepository.fetchingConfig(
      WebSocketSubscriber(
        (data) {
          event.onConfigurationFetched(ConfigurationDto.fromJson(data));
        },
      ),
    );
  }

  void _onFetchEntities(FetchEntites event, Emitter<WebSocketState> emit) {
    webSocketRepository.fetchingStates(
      WebSocketSubscriber(
        (data) {
          event.onEntitiesFetched(
            (data as List<dynamic>).getEntities<Entity>(),
          );
        },
      ),
    );
  }
}
