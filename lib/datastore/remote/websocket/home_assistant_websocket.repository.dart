import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/error/error.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/response/response.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/service/service_body.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/trigger/trigger_body.dto.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant.broker.dart';
import 'package:homsai/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketSubscriber {
  Function(dynamic) onDone;
  Function(ErrorDto)? onError;

  WebSocketSubscriber(
    this.onDone, {
    this.onError,
  });
}

class WebSocketSubscribersHandler {
  Map<Function(Map<String, dynamic>), WebSocketSubscriber> subscribers = {};
  bool isfetch;
  String event;

  WebSocketSubscribersHandler(
    this.isfetch,
    this.event,
  );

  void subscribe(WebSocketSubscriber subscriber) {
    subscribers[subscriber.onDone] = subscriber;
  }

  void unsubscribe(WebSocketSubscriber subscriber) {
    subscribers.remove(subscriber.onDone);
  }

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

enum HomeAssistantWebSocketStatus { disconnected, connected, error }

class HomeAssistantWebSocketRepository {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();

  WebSocketChannel? webSocket;
  HomeAssistantAuth? homeAssistantAuth;
  int id = 2;
  HomeAssistantWebSocketStatus status =
      HomeAssistantWebSocketStatus.disconnected;
  final List<String> _message = [];

  late Uri url;

  static Map<String, int> eventsId = {};
  static Map<int, WebSocketSubscribersHandler> events = {};

  bool isConnected() {
    return status == HomeAssistantWebSocketStatus.connected;
  }

  T _fallback<T>(
    Uri? url,
    Uri? fallbackUrl,
    T Function(Uri) function,
  ) {
    try {
      throwIf(url == null, SocketException);
      return function(url!);
    } on SocketException catch (e) {
      try {
        throwIf(fallbackUrl == null, e);
        return function(fallbackUrl!);
      } on SocketException {
        rethrow;
      }
    }
  }

  Future<void> connect(
    Uri? url,
    Uri? fallbackUrl,
  ) {
    return _fallback<Future<void>>(
      url,
      fallbackUrl,
      _connect,
    );
  }

  Future<void> _connect(Uri url) async {
    String scheme;

    homeAssistantAuth = appPreferencesInterface.getHomeAssistantToken();

    if (homeAssistantAuth!.expires <
        DateTime.now().millisecondsSinceEpoch ~/ 1000) {
      homeAssistantAuth = await homeAssistantRepository.refreshToken(url: url);
      appPreferencesInterface.setHomeAssistantToken(homeAssistantAuth!);
    }

    scheme = url.scheme.contains('s') ? 'wss' : 'ws';

    url = url.replace(
      path: HomeAssistantApiProprties.webSocketPath,
      scheme: scheme,
    );

    this.url = url;

    _message.insert(
      0,
      jsonEncode({
        "type": "auth",
        "access_token": homeAssistantAuth!.token,
      }),
    );

    getIt.get<HomeAssistantBroker>().connect();

    _listen();
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

  void _listen() {
    webSocket = WebSocketChannel.connect(url);

    webSocket?.stream.listen(
      (data) {
        //TODO: remove
        print(data);

        data = jsonDecode(data);

        switch (status) {
          case HomeAssistantWebSocketStatus.disconnected:
            _auth(data);
            break;
          case HomeAssistantWebSocketStatus.connected:
            try {
              _responseHandler(data);
            } catch (e) {
              //TODO: remove
              print(data);
              print(e);
            }
            break;
          default:
        }
      },
      onDone: () {
        if (status == HomeAssistantWebSocketStatus.connected) {
          status = HomeAssistantWebSocketStatus.disconnected;
          _connect(url);
        }
      },
      onError: (e) {
        if (e is WebSocketChannelException) {
          var error = e.inner;
          if (error is WebSocketChannelException) {
            if (error.inner is SocketException) throw error.inner as SocketException;
          }

          status = HomeAssistantWebSocketStatus.error;
        }
      },
    );
  }

  void _send({
    bool flush = false,
    bool force = false,
  }) {
    if (status == HomeAssistantWebSocketStatus.disconnected && !force) return;
    if (!flush) return webSocket?.sink.add(_message.removeAt(0));

    while (_message.isNotEmpty) {
      webSocket?.sink.add(_message.removeAt(0));
    }
  }

  void logOut() {
    status = HomeAssistantWebSocketStatus.disconnected;
    webSocket?.sink.close();
    homeAssistantRepository.revokeToken(url: url);
  }

  void _addSubscriber(
    String event,
    WebSocketSubscriber subscriber,
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

  void removeSubscription(
    String event,
    WebSocketSubscriber subscriber,
  ) {
    if (eventsId.containsKey(event) &&
        events[eventsId[event]]!.subscribers.isNotEmpty) {
      events[eventsId[event]]!.unsubscribe(subscriber);
    }
  }

  ///////////////////
  // Subscriptions
  ///////////////////

  void subscribeEvent(
    String event,
    WebSocketSubscriber subscriber,
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

  void subscribeTrigger(
    String event,
    WebSocketSubscriber subscriber,
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

  void unsubscribingFromEvents(
    String event,
    WebSocketSubscriber subscriber,
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

  void fireAnEvent(
    WebSocketSubscriber subscriber,
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

  void callingAService(
    WebSocketSubscriber subscriber,
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

  void fetchingStates(WebSocketSubscriber subscriber) {
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

  void fetchingConfig(WebSocketSubscriber subscriber) {
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

  void fetchingServices(WebSocketSubscriber subscriber) {
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

  void fetchingMediaPlayerThumbnails(
    WebSocketSubscriber subscriber,
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

  void validateConfig(
    WebSocketSubscriber subscriber,
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
}
