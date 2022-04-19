import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:network_info_plus/network_info_plus.dart';

class HomeAssistantScannerRepository implements HomeAssistantScannerInterface {
  @override
  Stream<String> scanNetwork({Duration timeout = const Duration(seconds: 3)}) {
    late StreamController<String> controller;
    bool cancel = false;

    void startScan() async {
      String? ip = await (NetworkInfo().getWifiIP());
      String? subMask = await (NetworkInfo().getWifiSubmask());

      throwIf(ip == null, Exception('Invalid ip address'));
      throwIf(subMask == null || subMask != '255.255.255.0',
          Exception('Invalid subnet'));

      final String net = ip!.substring(0, ip.lastIndexOf('.'));
      const int port = 8123;

      int remainingHosts = 253;

      for (int host = 1; host < 255 && !cancel; host++) {
        ip = '$net.$host';
        Socket.connect(ip, port, timeout: timeout).then((socket) async {
          Uri? host = Uri(
            host: socket.address.address,
            scheme: 'http',
            port: port,
          );

          host = await canConnectToHomeAssistant(url: host);

          if (host != null) {
            controller.add(host.toString());
          }

          socket.destroy();

          remainingHosts == 0 ? controller.close() : remainingHosts--;
        }).catchError((e) {
          remainingHosts == 0 ? controller.close() : remainingHosts--;
        });
      }
    }

    void cancelScan() {
      cancel = true;
    }

    controller = StreamController<String>(
      onListen: startScan,
      onCancel: cancelScan,
    );

    return controller.stream;
  }

  @override
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      HttpClient client = HttpClient();
      client.connectionTimeout = timeout;
      await client.get(url.host, url.port, url.path);
      client.close();
      return url;
    } catch (e) {
      return null;
    }
  }
}
