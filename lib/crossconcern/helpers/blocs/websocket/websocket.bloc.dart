import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/device_related/device_related.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/device_related/device_related_body.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/area/base.area.dart';
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

  final HomsaiDatabase appDatabase = getIt.get<HomsaiDatabase>();

  WebSocketBloc() : super(const WebSocketState()) {
    on<ConnectWebSocket>(_onWebsocketConnect);
    on<FetchConfig>(_onFetchConfig);
    on<FetchEntities>(_onFetchEntities);
  }

  @override
  void onTransition(Transition<WebSocketEvent, WebSocketState> transition) {
    super.onTransition(transition);
  }

  void _onWebsocketConnect(
      ConnectWebSocket event, Emitter<WebSocketState> emit) async {
    if (event.baseUrl.isNotEmpty) {
      return webSocketRepository.connect(
        baseUrl: Uri.parse(event.baseUrl),
        fallback: event.fallback.isNotEmpty ? Uri.parse(event.baseUrl) : null,
        onConnected: event.onWebSocketConnected,
      );
    }
    webSocketRepository.connect(onConnected: event.onWebSocketConnected);
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

  void _onFetchEntities(FetchEntities event, Emitter<WebSocketState> emit) {
    webSocketRepository.getAreaList(WebSocketSubscriber((data) {
      Map<String, Area> areas = {};

      (data as List<dynamic>)
          .getAreas()
          .forEach((area) => areas.putIfAbsent(area.id, () => area));

      webSocketRepository.fetchingStates(
        WebSocketSubscriber((data) {
          Map<String, Entity> entities = {};

          (data as List<dynamic>).getEntities<Entity>().forEach(
              (entity) => entities.putIfAbsent(entity.entityId, () => entity));

          webSocketRepository.getDeviceList(WebSocketSubscriber((data) {
            final devicesDto = (data as List<dynamic>).getDevicesDto();

            List<String> ids = devicesDto.map((d) => d.id).toList();

            for (var deviceDto in devicesDto) {
              webSocketRepository.getDeviceRelated(WebSocketSubscriber((data) {
                final deviceRelatedDto = DeviceRelatedDto.fromJson(data);
                if (deviceRelatedDto.entity != null) {
                  for (var entityId in deviceRelatedDto.entity!) {
                    entities[entityId]?.area = areas[deviceDto.area];
                  }
                }

                ids.remove(deviceDto.id);
                if (ids.isEmpty) {
                  event.onEntitiesFetched(entities.values.toList());
                }
              }), DeviceRelatedBodyDto(deviceDto.id));
            }
          }));
        }),
      );
    }));
  }
}
