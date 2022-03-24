import 'dart:async';

import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:lan_scanner/lan_scanner.dart';

abstract class HomeAssistantInterface {
  Future<HomeAssistantAuth> authenticate({required Uri url});
  StreamSubscription<HostModel> scan({
    required List<String> hosts,
    required void Function(String) onData,
    Function? onError,
  });
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  });
  Future<List<String>> discoverAvailableHosts();
}
