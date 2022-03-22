import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class HomeAssistantInterface {
  Future<HomeAssistantAuth> authenticate({required Uri url});
  Future<List<String>> startScan({
    void Function(double)? progressCallback,
  });
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  });
}
