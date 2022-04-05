import 'dart:async';

import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class HomeAssistantInterface {
  Future<HomeAssistantAuth> authenticate({required Uri url});
  Future<StreamSubscription<String>> scan({
    required void Function(String) onData,
    Function? onError,
  });
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  });

  Future refreshToken({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  });

  Future revokeToken({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  });
}
