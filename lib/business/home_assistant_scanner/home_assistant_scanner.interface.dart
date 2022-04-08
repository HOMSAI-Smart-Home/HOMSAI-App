import 'dart:async';

abstract class HomeAssistantScannerInterface {
  Stream<String> scanNetwork({Duration timeout = const Duration(seconds: 1)});

  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  });
}
