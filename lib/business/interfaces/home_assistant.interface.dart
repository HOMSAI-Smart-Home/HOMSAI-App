import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class HomeAssistantInterface {
  Future<HomeAssistantAuth> authenticate({required String url});
  Future<List<String>> startScan({
    void Function(double)? progressCallback,
  });
  Future<String?> canConnectToHomeAssistant({
    required String host,
    int port = 8123,
    Duration timeout = const Duration(seconds: 2),
  });
}
