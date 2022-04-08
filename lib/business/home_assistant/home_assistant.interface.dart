import 'dart:async';

import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class HomeAssistantInterface {
  Future<HomeAssistantAuth> authenticate({required Uri url});
  StreamSubscription<String> scan({
    required void Function(String) onData,
    Function? onError,
  });
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  });
}
