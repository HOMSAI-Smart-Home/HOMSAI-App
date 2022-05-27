import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/device_related/device_related_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/error/error.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/response/response.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/service/service_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/trigger/trigger_body.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant.broker.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketSubscriber implements WebSocketSubscriberInterface {
  @override
  Function(dynamic) onDone;
  @override
  Function(ErrorDto)? onError;

  WebSocketSubscriber(
    this.onDone, {
    this.onError,
  });
}

class WebSocketSubscribersHandler
    implements WebSocketSubscribersHandlerInterface {
  Map<Function(Map<String, dynamic>), WebSocketSubscriberInterface>
      subscribers = {};
  bool isfetch;
  String event;

  WebSocketSubscribersHandler(
    this.isfetch,
    this.event,
  );

  @override
  void subscribe(WebSocketSubscriberInterface subscriber) {
    subscribers[subscriber.onDone] = subscriber;
  }

  @override
  void unsubscribe(WebSocketSubscriberInterface subscriber) {
    subscribers.remove(subscriber.onDone);
  }

  @override
  void publish(dynamic result) {
    if (result == null) return;

    subscribers.forEach((key, value) {
      if (result is ErrorDto) {
        value.onError != null ? value.onError!(result) : {};
      } else {
        value.onDone(result);
      }
    });
  }
}

class HomeAssistantWebSocketRepository
    implements HomeAssistantWebSocketInterface {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();
  final AppDatabase appDatabase = getIt.get<AppDatabase>();

  WebSocketChannel? webSocket;
  HomeAssistantAuth? homeAssistantAuth;
  int id = 2;
  HomeAssistantWebSocketStatus status =
      HomeAssistantWebSocketStatus.disconnected;
  final List<String> _message = [];

  Plant? _plant;

  static Map<String, int> eventsId = {};
  static Map<int, WebSocketSubscribersHandler> events = {};

  List<Function> onConnected = [];

  @override
  bool isConnected() {
    return status == HomeAssistantWebSocketStatus.connected;
  }

  @override
  bool isConnecting() {
    return status == HomeAssistantWebSocketStatus.connecting ||
        status == HomeAssistantWebSocketStatus.retry;
  }

  @override
  Future<void> connect({
    Uri? baseUrl,
    Uri? fallback,
    Function? onConnected,
  }) async {
    if (isConnected()) {
      if (onConnected != null) onConnected();
      return;
    }
    if (onConnected != null) this.onConnected.add(onConnected);
    if (isConnecting()) return;

    status = HomeAssistantWebSocketStatus.connecting;

    if (baseUrl != null) {
      return await _listen(
        baseUrl,
        retry: (exeption) {
          if (fallback != null &&
              status != HomeAssistantWebSocketStatus.retry) {
            status = HomeAssistantWebSocketStatus.retry;
            if (_message.isNotEmpty) _message.removeAt(0);
            _listen(fallback);
            return;
          }
          throw exeption;
        },
      );
    }

    _plant = await appDatabase.getPlant();

    if (_plant != null) {
      return await _listen(_plant!.getBaseUrl());
    }
  }

  @override
  Future<void> reconnect({Function? onConnected}) async {
    _plant = await appDatabase.getPlant();
    await logout();

    if (onConnected != null) this.onConnected.add(onConnected);

    if (_plant != null) {
      return _listen(
        _plant!.getBaseUrl(),
      );
    }
  }

  Future<Uri> _connect(
    Uri url, {
    Duration timeout = const Duration(seconds: 1),
  }) async {
    String scheme = url.scheme.contains('s') ? 'wss' : 'ws';

    homeAssistantAuth = appPreferencesInterface.getHomeAssistantToken();

    if (homeAssistantAuth!.expires <
        DateTime.now().millisecondsSinceEpoch ~/ 1000) {
      homeAssistantAuth = await homeAssistantRepository.refreshToken(
        url: url,
        timeout: timeout,
      );
      appPreferencesInterface.setHomeAssistantToken(homeAssistantAuth!);
    }

    url = url.replace(
      path: HomeAssistantApiProprties.webSocketPath,
      scheme: scheme,
    );

    _message.insert(
      0,
      jsonEncode({
        "type": "auth",
        "access_token": homeAssistantAuth!.token,
      }),
    );

    getIt.get<HomeAssistantBroker>().connect();

    return url;
  }

  void _auth(Map<String, dynamic> data) {
    switch (data["type"]) {
      case HomeAssistantApiProprties.authRequired:
        _send(force: true);
        break;

      case HomeAssistantApiProprties.authOk:
        status = HomeAssistantWebSocketStatus.connected;
        _send(flush: true);
        return;

      case HomeAssistantApiProprties.authInvalid:
        throw Exception(data["message"]);
    }
  }

  void _responseHandler(Map<String, dynamic> data) {
    ResponseDto response = ResponseDto.fromJson(data);

    if (response.success ?? false) {
      events[response.id]!.publish(response.result);
    } else {
      if (response.event != null) {
        events[response.id]!.publish(response.event);
      } else {
        events[response.id]!.publish(response.error);
      }
    }

    if (events[response.id]?.isfetch ?? false) {
      _removeEvent(response.id);
    }
  }

  Future<void> _listen(Uri url, {Function(Exception exception)? retry}) async {
    try {
      if (status != HomeAssistantWebSocketStatus.retry) {
        status = HomeAssistantWebSocketStatus.connecting;
      }

      url = await _connect(url);
      webSocket = IOWebSocketChannel(
        await WebSocket.connect(url.toString())
            .timeout(const Duration(seconds: 3)),
      );

      while (onConnected.isNotEmpty) {
        onConnected.removeAt(0)();
      }

      webSocket?.stream.listen(
        (data) {
          if (kDebugMode) {
            print(data);
          }

          data = jsonDecode(data);

          switch (status) {
            case HomeAssistantWebSocketStatus.retry:
            case HomeAssistantWebSocketStatus.connecting:
              _auth(data);
              break;
            case HomeAssistantWebSocketStatus.connected:
              try {
                _responseHandler(data);
              } catch (e) {
                if (kDebugMode) {
                  print(data);
                  print(e);
                }
              }
              break;
            default:
          }
        },
        onDone: () async {
          if (status == HomeAssistantWebSocketStatus.connected) {
            status = HomeAssistantWebSocketStatus.disconnected;
            await Future.delayed(const Duration(seconds: 1));
            _listen(url);
          }
        },
        onError: (e) {
          if (e is WebSocketChannelException) {
            var error = e.inner;
            if (error is WebSocketChannelException) {
              if (error.inner is SocketException) {
                return;
              }
            }
          }
          status = HomeAssistantWebSocketStatus.error;
        },
      );
    } catch (e) {
      if ((e is SocketException || e is TimeoutException) &&
          status != HomeAssistantWebSocketStatus.error) {
        return retry != null
            ? retry(e as Exception)
            : _retry(url, e as Exception);
      }
      rethrow;
    }
  }

  void _retry(Uri url, Exception e) {
    if (_plant != null && status != HomeAssistantWebSocketStatus.retry) {
      final fallback = _plant?.getFallbackUrl();
      if (fallback != null) {
        status = HomeAssistantWebSocketStatus.retry;
        if (_message.isNotEmpty) _message.removeAt(0);
        _listen(fallback);
        return;
      }
    }
    throw e;
  }

  void _send({
    bool flush = false,
    bool force = false,
  }) {
    if (status != HomeAssistantWebSocketStatus.connected && !force) return;
    if (kDebugMode) {
      print(_message);
    }
    if (!flush) return webSocket?.sink.add(_message.removeAt(0));

    while (_message.isNotEmpty) {
      webSocket?.sink.add(_message.removeAt(0));
    }
  }

  @override
  Future<void> logout() async {
    events = {};
    eventsId = {};
    status = HomeAssistantWebSocketStatus.disconnected;
    await webSocket?.sink.close();
  }

  void _addSubscriber(
    String event,
    WebSocketSubscriberInterface subscriber,
    bool isfetch,
    Map<String, dynamic> payload,
  ) {
    if (isfetch || !eventsId.containsKey(event)) {
      if (!isfetch) eventsId[event] = id;

      events[id] = WebSocketSubscribersHandler(isfetch, event);

      _message.add(jsonEncode(payload));
      _send();
    }

    events[isfetch ? id : eventsId[event]]!.subscribe(subscriber);
    id++;
  }

  void _removeEvent(int id) {
    if (events.containsKey(id)) {
      if (!events[id]!.isfetch) {
        eventsId.remove(events[id]!.event);
      }
      events.remove(id);
    }
  }

  @override
  void removeSubscription(
    String event,
    WebSocketSubscriberInterface subscriber,
  ) {
    if (eventsId.containsKey(event) &&
        events[eventsId[event]]!.subscribers.isNotEmpty) {
      events[eventsId[event]]!.unsubscribe(subscriber);
    }
  }

  ///////////////////
  // Subscriptions
  ///////////////////

  @override
  void subscribeEvent(
    String event,
    WebSocketSubscriberInterface subscriber,
  ) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(event) ? eventsId[event] : id;
    payload['type'] = HomeAssistantApiProprties.fetchingSubscribeEvents;
    payload['event_type'] = event;

    _addSubscriber(
      event,
      subscriber,
      false,
      payload,
    );
  }

  @override
  void subscribeTrigger(
    String event,
    WebSocketSubscriberInterface subscriber,
    TriggerBodyDto trigger,
  ) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingSubscribeTrigger)
            ? eventsId[HomeAssistantApiProprties.fetchingSubscribeTrigger]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingSubscribeTrigger;
    payload['trigger'] = trigger.toJson();

    _addSubscriber(
      HomeAssistantApiProprties.fetchingSubscribeTrigger,
      subscriber,
      false,
      payload,
    );
  }

  @override
  void unsubscribingFromEvents(
    String event,
    WebSocketSubscriberInterface subscriber,
  ) {
    Map<String, dynamic> payload = {};

    if (!eventsId.containsKey(event)) return;

    payload['id'] = eventsId
            .containsKey(HomeAssistantApiProprties.fetchingUnsubscribeEvents)
        ? eventsId[HomeAssistantApiProprties.fetchingUnsubscribeEvents]
        : id;
    payload['type'] = HomeAssistantApiProprties.fetchingUnsubscribeEvents;
    payload['subscription'] = eventsId[event];

    _addSubscriber(
      HomeAssistantApiProprties.fetchingUnsubscribeEvents,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void fireAnEvent(
    WebSocketSubscriberInterface subscriber,
    String eventType, {
    Map<String, String>? eventData,
  }) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(HomeAssistantApiProprties.fireEvent)
        ? eventsId[HomeAssistantApiProprties.fireEvent]
        : id;
    payload['type'] = HomeAssistantApiProprties.fireEvent;
    payload['event_type'] = eventType;
    eventData != null ? payload['event_data'] = eventData : null;

    _addSubscriber(
      HomeAssistantApiProprties.fireEvent,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void callingAService(
    WebSocketSubscriberInterface subscriber,
    String domain,
    String service,
    ServiceBodyDto serviceBodyDto,
  ) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(HomeAssistantApiProprties.callService)
        ? eventsId[HomeAssistantApiProprties.callService]
        : id;
    payload['type'] = HomeAssistantApiProprties.callService;
    payload['domain'] = domain;
    payload['service'] = service;
    payload['target'] = serviceBodyDto.target;

    _addSubscriber(
      HomeAssistantApiProprties.callService,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void fetchingStates(WebSocketSubscriberInterface subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingStates)
            ? eventsId[HomeAssistantApiProprties.fetchingStates]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingStates;

    _addSubscriber(
      HomeAssistantApiProprties.fetchingStates,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void fetchingConfig(WebSocketSubscriberInterface subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingConfig)
            ? eventsId[HomeAssistantApiProprties.fetchingConfig]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingConfig;

    _addSubscriber(
      HomeAssistantApiProprties.fetchingConfig,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void fetchingServices(WebSocketSubscriberInterface subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingServices)
            ? eventsId[HomeAssistantApiProprties.fetchingServices]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingServices;

    _addSubscriber(
      HomeAssistantApiProprties.fetchingServices,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void fetchingMediaPlayerThumbnails(
    WebSocketSubscriberInterface subscriber,
    String entityId,
  ) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId
            .containsKey(HomeAssistantApiProprties.fetchingMediaPlayerThumbnail)
        ? eventsId[HomeAssistantApiProprties.fetchingMediaPlayerThumbnail]
        : id;
    payload['type'] = HomeAssistantApiProprties.fetchingMediaPlayerThumbnail;
    payload['entity_id'] = entityId;

    _addSubscriber(
      HomeAssistantApiProprties.fetchingMediaPlayerThumbnail,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void validateConfig(
    WebSocketSubscriberInterface subscriber,
    String entityId,
    ConfigurationBodyDto configurationBodyDto,
  ) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.validateConfig)
            ? eventsId[HomeAssistantApiProprties.validateConfig]
            : id;
    payload['type'] = HomeAssistantApiProprties.validateConfig;
    payload.addAll(configurationBodyDto.toJson());

    _addSubscriber(
      HomeAssistantApiProprties.validateConfig,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void getDeviceList(WebSocketSubscriberInterface subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(HomeAssistantApiProprties.deviceList)
        ? eventsId[HomeAssistantApiProprties.deviceList]
        : id;
    payload['type'] = HomeAssistantApiProprties.deviceList;

    _addSubscriber(
      HomeAssistantApiProprties.deviceList,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void getAreaList(WebSocketSubscriberInterface subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(HomeAssistantApiProprties.areaList)
        ? eventsId[HomeAssistantApiProprties.areaList]
        : id;
    payload['type'] = HomeAssistantApiProprties.areaList;

    _addSubscriber(
      HomeAssistantApiProprties.areaList,
      subscriber,
      true,
      payload,
    );
  }

  @override
  void getDeviceRelated(
    WebSocketSubscriberInterface subscriber,
    DeviceRelatedBodyDto deviceRelatedBodyDto,
  ) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.entitysFromDevice)
            ? eventsId[HomeAssistantApiProprties.entitysFromDevice]
            : id;
    payload['type'] = HomeAssistantApiProprties.entitysFromDevice;
    payload.addAll(deviceRelatedBodyDto.toJson());

    _addSubscriber(
      HomeAssistantApiProprties.entitysFromDevice,
      subscriber,
      true,
      payload,
    );
  }
}
