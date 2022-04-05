import 'dart:convert';

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

  WebSocketSubscriber(this.onDone, {this.onError});
}

class WebSocketSubscribersHandler {
  Map<Function(Map<String, dynamic>), WebSocketSubscriber> subscribers = {};
  bool isfetch;
  String event;

  WebSocketSubscribersHandler(this.isfetch, this.event);

  void subscribe(WebSocketSubscriber subscriber) {
    subscribers[subscriber.onDone] = subscriber;
  }

  void unsubscribe(WebSocketSubscriber subscriber) {
    subscribers.remove(subscriber.onDone);
  }

  void publish(dynamic result) {
    if (result == null) return;

    subscribers.forEach((key, value) {
      if (result is ErrorDto && value.onError != null) {
        value.onError!(result);
      } else {
        value.onDone(result);
      }
    });
  }
}

class HomeAssistantWebSocketRepository {
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  final HomeAssistantInterface homeAssistantRepository =
      getIt.get<HomeAssistantInterface>();

  WebSocketChannel? webSocket;
  HomeAssistantAuth? homeAssistantAuth;
  int id = 2;
  bool _connected = false;
  final List<String> _message = [];

  //TODO: Remove and take it from global.
  late Uri url;

  static Map<String, int> eventsId = {};
  static Map<int, WebSocketSubscribersHandler> events = {};

  bool isConnected() {
    return _connected;
  }

  Future<void> connect(Uri url) async {
    String scheme;

    homeAssistantAuth = appPreferencesInterface.getToken();

    if (homeAssistantAuth!.expires <
        DateTime.now().millisecondsSinceEpoch ~/ 1000) {
      await homeAssistantRepository.refreshToken(url: url);
      homeAssistantAuth = appPreferencesInterface.getToken();
    }

    scheme = url.scheme.contains('s') ? 'wss' : 'ws';

    url = url.replace(
        path: HomeAssistantApiProprties.webSocketPath, scheme: scheme);

    this.url = url;

    _message.insert(0, jsonEncode({"type": "auth", "access_token": homeAssistantAuth!.token}));

    getIt.get<HomeAssistantBroker>().connect();

    _listen();
  }

  void _auth(Map<String, dynamic> data) {
    switch (data["type"]) {
      case HomeAssistantApiProprties.authRequired:
        _send(force: true);
        break;

      case HomeAssistantApiProprties.authOk:
        _connected = true;
        _send(flush: true);
        return;

      case HomeAssistantApiProprties.authInvalid:
        throw Exception(data["message"]);
    }
  }

  void responseHandler(Map<String, dynamic> data) {
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

        if (!_connected) {
          _auth(data);
        } else {
          responseHandler(data);
        }
      },
      onDone: () => connect(url),
      onError: (e) => connect(url),
    );
  }

  void _send({bool flush = false, bool force = false}) {
    if (!_connected && !force) return;
    if (!flush) return webSocket?.sink.add(_message.removeAt(0));

    while (_message.isNotEmpty) {
      webSocket?.sink.add(_message.removeAt(0));
    }
  }

  void close() {
    _connected = false;
    webSocket?.sink.close();
  }

  void _addSubscriber(String event, WebSocketSubscriber subscriber,
      bool isfetch, Map<String, dynamic> payload) {
    if (isfetch || !eventsId.containsKey(event)) {
      eventsId[event] = id++;
      events[eventsId[event]!] = WebSocketSubscribersHandler(isfetch, event);

      _message.add(jsonEncode(payload));
      _send();
    }

    events[eventsId[event]]!.subscribe(subscriber);
  }

  void _removeEvent(int id) {
    if (events.containsKey(id)) {
      eventsId.remove(events[id]?.event);
      events.remove(id);
    }
  }

  void removeSubscription(String event, WebSocketSubscriber subscriber) {
    if (eventsId.containsKey(event) &&
        events[eventsId[event]]!.subscribers.isNotEmpty) {
      events[eventsId[event]]!.unsubscribe(subscriber);
    }
  }

  ///////////////////
  // Subscriptions
  ///////////////////

  void subscribeEvent(String event, WebSocketSubscriber subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(event) ? eventsId[event] : id;
    payload['type'] = HomeAssistantApiProprties.fetchingSubscribeEvents;
    payload['event_type'] = event;

    _addSubscriber(event, subscriber, false, payload);
  }

  void subscribeTrigger(
      String event, WebSocketSubscriber subscriber, TriggerBodyDto trigger) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingSubscribeTrigger)
            ? eventsId[HomeAssistantApiProprties.fetchingSubscribeTrigger]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingSubscribeTrigger;
    payload['trigger'] = trigger.toJson();

    _addSubscriber(HomeAssistantApiProprties.fetchingSubscribeTrigger,
        subscriber, false, payload);
  }

  void unsubscribingFromEvents(String event, WebSocketSubscriber subscriber) {
    Map<String, dynamic> payload = {};

    if (!eventsId.containsKey(event)) return;

    payload['id'] = eventsId
            .containsKey(HomeAssistantApiProprties.fetchingUnsubscribeEvents)
        ? eventsId[HomeAssistantApiProprties.fetchingUnsubscribeEvents]
        : id;
    payload['type'] = HomeAssistantApiProprties.fetchingUnsubscribeEvents;
    payload['subscription'] = eventsId[event];

    _addSubscriber(HomeAssistantApiProprties.fetchingUnsubscribeEvents,
        subscriber, true, payload);
  }

  void fireAnEvent(WebSocketSubscriber subscriber, String eventType,
      {Map<String, String>? eventData}) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(HomeAssistantApiProprties.fireEvent)
        ? eventsId[HomeAssistantApiProprties.fireEvent]
        : id;
    payload['type'] = HomeAssistantApiProprties.fireEvent;
    payload['event_type'] = eventType;
    eventData != null ? payload['event_data'] = eventData : null;

    _addSubscriber(
        HomeAssistantApiProprties.fireEvent, subscriber, true, payload);
  }

  void callingAService(WebSocketSubscriber subscriber, String domain,
      String service, ServiceBodyDto serviceBodyDto) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId.containsKey(HomeAssistantApiProprties.callService)
        ? eventsId[HomeAssistantApiProprties.callService]
        : id;
    payload['type'] = HomeAssistantApiProprties.callService;
    payload['domain'] = domain;
    payload['service'] = service;
    payload['target'] = serviceBodyDto.target;
    // payload.addAll(serviceBodyDto.toJson());

    _addSubscriber(
        HomeAssistantApiProprties.callService, subscriber, true, payload);
  }

  void fetchingStates(WebSocketSubscriber subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingStates)
            ? eventsId[HomeAssistantApiProprties.fetchingStates]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingStates;

    _addSubscriber(
        HomeAssistantApiProprties.fetchingStates, subscriber, true, payload);
  }

  void fetchingConfig(WebSocketSubscriber subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingConfig)
            ? eventsId[HomeAssistantApiProprties.fetchingConfig]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingConfig;

    _addSubscriber(
        HomeAssistantApiProprties.fetchingConfig, subscriber, true, payload);
  }

  void fetchingServices(WebSocketSubscriber subscriber) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.fetchingServices)
            ? eventsId[HomeAssistantApiProprties.fetchingServices]
            : id;
    payload['type'] = HomeAssistantApiProprties.fetchingServices;

    _addSubscriber(
        HomeAssistantApiProprties.fetchingServices, subscriber, true, payload);
  }

  void fetchingMediaPlayerThumbnails(
      WebSocketSubscriber subscriber, String entityId) {
    Map<String, dynamic> payload = {};

    payload['id'] = eventsId
            .containsKey(HomeAssistantApiProprties.fetchingMediaPlayerThumbnail)
        ? eventsId[HomeAssistantApiProprties.fetchingMediaPlayerThumbnail]
        : id;
    payload['type'] = HomeAssistantApiProprties.fetchingMediaPlayerThumbnail;
    payload['entity_id'] = entityId;

    _addSubscriber(HomeAssistantApiProprties.fetchingMediaPlayerThumbnail,
        subscriber, true, payload);
  }

  void validateConfig(WebSocketSubscriber subscriber, String entityId,
      ConfigurationBodyDto configurationBodyDto) {
    Map<String, dynamic> payload = {};

    payload['id'] =
        eventsId.containsKey(HomeAssistantApiProprties.validateConfig)
            ? eventsId[HomeAssistantApiProprties.validateConfig]
            : id;
    payload['type'] = HomeAssistantApiProprties.validateConfig;
    payload.addAll(configurationBodyDto.toJson());

    _addSubscriber(
        HomeAssistantApiProprties.validateConfig, subscriber, true, payload);
  }
}
