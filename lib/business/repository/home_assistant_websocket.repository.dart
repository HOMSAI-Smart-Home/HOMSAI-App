import 'dart:convert';

import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeAssistantWebSocketRepository {
  late WebSocketChannel webSocket;
  late HomeAssistantAuth? homeAssistantAuth;
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  void connect(Uri url) {
    homeAssistantAuth = appPreferencesInterface.getToken();

    url = url.replace(path: "/api/websocket", scheme: 'wss');
    webSocket = WebSocketChannel.connect(url);

    print("WebSocket");
    webSocket.stream.listen((data) {
      data = jsonDecode(data);

      print(data);

      if (data["type"] == "auth_required") {
        return webSocket.sink.add(jsonEncode(
            {"type": "auth", "access_token": homeAssistantAuth!.token}));
      }

      if (data["type"] == "auth_ok") {
        return;
      }
    });
  }

  /*Future<List<String>> getConfig(args) {
    return <String>[];
  }*/
}
