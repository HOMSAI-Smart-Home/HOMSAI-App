import 'dart:async';

abstract class HomeAssistantScannerInterface {
  Stream<String> scanNetwork({required Duration timeout});

  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout,
  });
}
