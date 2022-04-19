import 'dart:async';

abstract class HomeAssistantScannerInterface {
  Stream<String> scanNetwork({Duration timeout});

  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout,
  });
}
