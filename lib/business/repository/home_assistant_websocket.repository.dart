import 'dart:convert';

import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/DTOs/websocket/error.dto.dart';
import 'package:homsai/datastore/DTOs/websocket/response.dto.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Event {
  Map<Function(dynamic), Function(ErrorDto)?> subscribed = {};
  bool isfetch;
  String event;

  Event(this.isfetch, this.event);

  void subscribe(Function(dynamic) onDone, Function(ErrorDto)? onError) {
    subscribed[onDone] = onError;
  }

  void unsubscribe(Function(dynamic) onDone) {
    subscribed.remove(onDone);
  }

  void publish(dynamic result) {
    subscribed.forEach((key, value) {
      if (result is ErrorDto) {
        value!(result);
      } else {
        key(result);
      }
    });
  }
}

class HomeAssistantWebSocketRepository {
  late WebSocketChannel webSocket;
  late HomeAssistantAuth? homeAssistantAuth;
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  int id = 1;

  //TODO: Remove and take it from global.
  late Uri url;

  static Map<String, int> eventsId = {};
  static Map<int, Event> events = {};

  void connect(Uri url) {
    homeAssistantAuth = appPreferencesInterface.getToken();

    String scheme = url.scheme.contains('s') ? 'wss' : 'ws';

    url = url.replace(path: "/api/websocket", scheme: scheme);

    this.url = url;
    _connect();
  }

  void _connect() {
    webSocket = WebSocketChannel.connect(url);

    webSocket.stream.listen((data) {
      data = jsonDecode(data);

      switch (data["type"]) {
        case HomeAssistantApiProprties.authRequired:
          webSocket.sink.add(jsonEncode(
              {"type": "auth", "access_token": homeAssistantAuth!.token}));
          break;

        case HomeAssistantApiProprties.authOk:
          listen();
          break;

        case "auth_invalid":
          throw Exception(data["message"]);
      }
    });
  }

  void listen() {
    ResponseDto? response;
    webSocket.stream.listen((data) {
      response = ResponseDto.fromJson(jsonDecode(data));

      if (response != null && response!.success != null && response!.success!) {
        events[response?.id]?.publish(response!.result);
      } else {
        events[response?.id]?.publish(response!.error);
      }

      if (events[response!.id]!.isfetch) {
        _removeEvent(id);
      }
    }).onError((error) => _connect());
  }

  void addSubscription(String event, String payload, Function(dynamic) onDone,
      {bool isfetch = false, Function(dynamic)? onError}) {
    if (!eventsId.containsKey(event)) {
      eventsId[event] = id++;
      events[eventsId[event]!] = Event(isfetch, event);
    }

    webSocket.sink.add(payload);

    events[eventsId[event]]!.subscribe(onDone, onError);
  }

  void _removeEvent(int id) {
    if (events.containsKey(id)) {
      eventsId.remove(events[id]?.event);
      events.remove(id);
    }
  }

  void removeSubscription(String event, Function(dynamic) callback) {
    if (eventsId.containsKey(event) &&
        events[eventsId[event]]!.subscribed.isNotEmpty) {
      events[eventsId[event]]!.unsubscribe(callback);
    }
  }
}
