import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeAssistantWebSocketRepository {
  late WebSocketChannel webSocket;
  late HomeAssistantAuth? homeAssistantAuth;
  final AppPreferencesInterface appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();

  void connect() {
    homeAssistantAuth = appPreferencesInterface.getToken();

    throwIf(homeAssistantAuth?.url == null, Exception("change this placeholder"));

    webSocket = WebSocketChannel.connect(homeAssistantAuth!.url!);
    print("yoo");
    webSocket.stream.listen((data) {
      data = jsonDecode(data);

      print(data);

      if (data["type"] == "auth_required") {
        return webSocket.sink.add(jsonEncode({
          "type": "auth",
          "access_token": appPreferencesInterface.getToken()
        }));
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
