import 'dart:convert';

import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Event {
  Map<Function(dynamic), Function(dynamic)?> subscribed = {};
  bool isfetch;

  Event(this.isfetch);

  void subscribe(Function(dynamic) onDone, Function(dynamic)? onError) {
    subscribed[onDone] = onError;
  }

  void unsubscribe(Function(dynamic) onDone) {
    subscribed.remove(onDone);
  }
}

class HomeAssistantWebSocketRepository {
  late WebSocketChannel webSocket;
  late HomeAssistantAuth? homeAssistantAuth;
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  int id = 1;

  static Map<String, int> eventsId = {};
  static Map<int, Event> events = {};

  void connect(Uri url) {
    homeAssistantAuth = appPreferencesInterface.getToken();

    String scheme = url.scheme.contains('s') ? 'wss' : 'ws';

    url = url.replace(path: "/api/websocket", scheme: scheme);
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

        default:
          throw Exception('Replace this placeolder');
      }
    });
  }

  void listen() {
    webSocket.stream.listen((data) {
      data = jsonDecode(data);

      switch (data["type"]) {
        case 1:
          break;

        case 2:
          break;

        default:
          throw Exception('Replace this placeolder');
      }
    });
  }

  void addSubscription(String event, String payload, Function(dynamic) onDone,
      {bool isfetch = false, Function(dynamic)? onError}) {
    if (!eventsId.containsKey(event)) {
      eventsId[event] = id++;
      events[eventsId[event]!] = Event(isfetch);
    }

    webSocket.sink.add(payload);

    events[eventsId[event]]!.subscribe(onDone, onError);
  }

  /*void removeSubscription(String event, Function(dynamic) callback) {
    if (eventsId.containsKey(event) &&
        events[eventsId[event]]!.subscribed.isNotEmpty) {
      events[eventsId[event]]!.unsubscribe(callback);
    }
  }*/
}
