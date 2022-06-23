import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:homsai/crossconcern/exceptions/token.exception.dart';
import 'package:homsai/crossconcern/exceptions/url.exception.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/device_related/device_related.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/device_related/device_related_body.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/area/base.area.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/main.dart';

part 'websocket.event.dart';
part 'websocket.state.dart';

class WebSocketBlockSubscribersHandler {
  final List<Function> _urlException = [];
  final List<Function> _tokenException = [];

  void subscribe(Type type, void Function() subscriber) {
    if (type == UrlException) _urlException.add(subscriber);
    if (type == TokenException) _tokenException.add(subscriber);
  }

  void unsubscribe(void Function() subscriber) {
    _urlException.remove(subscriber);
    _tokenException.remove(subscriber);
  }

  void publish(Type type) {
    if (type == UrlException) _urlException.forEach(_execute);
    if (type == TokenException) _tokenException.forEach(_execute);
  }

  void _execute(Function function) => function();
}

class WebSocketBloc extends Bloc<WebSocketEvent, WebSocketState> {
  final HomeAssistantWebSocketInterface _webSocketInterface =
      getIt.get<HomeAssistantWebSocketInterface>();

  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  final HomsaiDatabase appDatabase = getIt.get<HomsaiDatabase>();

  final WebSocketBlockSubscribersHandler _webSocketBlockSubscribersHandler =
      WebSocketBlockSubscribersHandler();

  final List<Function> onReconnect = [];

  WebSocketBloc() : super(const WebSocketState()) {
    on<ConnectWebSocket>(_onWebsocketConnect);
    on<FetchConfig>(_onFetchConfig);
    on<FetchEntities>(_onFetchEntities);
    on<WebSocketLogOut>(_onlogOut);

    _webSocketInterface.setErrorFunction(onTokenException: (e) {
      _webSocketBlockSubscribersHandler.publish(TokenException);
    }, onUrlException: (e) {
      _webSocketBlockSubscribersHandler.publish(UrlException);
    }, onGenericException: (e) {
      throw e;
    });
  }

  bool get isConnected => _webSocketInterface.isConnected;
  bool get isNotConnected =>
      !_webSocketInterface.isConnected || !_webSocketInterface.isConnecting;
  bool get isConnecting => _webSocketInterface.isConnecting;

  void subscribeToReconnect(Function onReconnect) {
    this.onReconnect.add(onReconnect);

    final networkManagerInterface = getIt.get<NetworkManagerInterface>();
    networkManagerInterface.subscribe(NetworkManagerSubscriber(
      (state) async {
        switch (state) {
          case ConnectivityResult.wifi:
          case ConnectivityResult.ethernet:
          case ConnectivityResult.mobile:
            final homsaiDatabase = getIt.get<HomsaiDatabase>();
            final plant = await homsaiDatabase.getPlant();

            if (plant != null) {
              await _onWebsocketConnect(
                ConnectWebSocket(onWebSocketConnected: () {
                  for (var element in this.onReconnect) {
                    element();
                  }
                }),
                null,
              );
            }

            break;
          case ConnectivityResult.bluetooth:
          case ConnectivityResult.none:
            _webSocketInterface.logout();
        }
      },
    ));
  }

  void subscribeToExeption(Type type, void Function() subscriber) =>
      _webSocketBlockSubscribersHandler.subscribe(type, subscriber);

  void unsubscribeToExeption(void Function() subscriber) =>
      _webSocketBlockSubscribersHandler.unsubscribe(subscriber);

  @override
  void onTransition(Transition<WebSocketEvent, WebSocketState> transition) {
    super.onTransition(transition);
  }

  Future<void> _onWebsocketConnect(
    ConnectWebSocket event,
    Emitter<WebSocketState>? emit,
  ) async {
    try {
      await _webSocketInterface.connect(
        baseUrl: event.baseUrl.isNotEmpty ? Uri.parse(event.baseUrl) : null,
        fallback: event.fallback.isNotEmpty ? Uri.parse(event.fallback) : null,
        onConnected: event.onWebSocketConnected,
      );
    } on UrlException {
      _webSocketBlockSubscribersHandler.publish(UrlException);
    } on TokenException {
      _webSocketBlockSubscribersHandler.publish(TokenException);
    }
  }

  void _onFetchConfig(FetchConfig event, Emitter<WebSocketState> emit) {
    _webSocketInterface.fetchingConfig(
      WebSocketSubscriber(
        (data) {
          event.onConfigurationFetched(ConfigurationDto.fromJson(data));
        },
      ),
    );
  }

  void _onFetchEntities(FetchEntities event, Emitter<WebSocketState> emit) {
    _webSocketInterface.getAreaList(WebSocketSubscriber((data) {
      log(jsonEncode(data));
      Map<String, Area> areas = {};

      (data as List<dynamic>)
          .getAreas()
          .forEach((area) => areas.putIfAbsent(area.id, () => area));

      _webSocketInterface.fetchingStates(
        WebSocketSubscriber((data) {
          Map<String, Entity> entities = {};

          (data as List<dynamic>).getEntities<Entity>().forEach(
              (entity) => entities.putIfAbsent(entity.entityId, () => entity));

          _webSocketInterface.getDeviceList(WebSocketSubscriber((data) {
            final devicesDto = (data as List<dynamic>).getDevicesDto();

            List<String> ids = devicesDto.map((d) => d.id).toList();

            for (var deviceDto in devicesDto) {
              _webSocketInterface.getDeviceRelated(WebSocketSubscriber((data) {
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

  Future<void> _onlogOut(
      WebSocketLogOut event, Emitter<WebSocketState> emit) async {
    await _webSocketInterface.logout();
    if (event.onLogOut != null) event.onLogOut!();
  }
}
