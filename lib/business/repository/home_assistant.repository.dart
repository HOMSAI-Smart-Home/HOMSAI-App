import 'dart:async';
import 'dart:io';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/interfaces/home_assistant.interface.dart';
import 'package:homsai/crossconcern/exceptions/scanning_not_found.exception.dart';
import 'package:homsai/crossconcern/helpers/extensions/ipv4.extension.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';

class HomeAssistantRepository implements HomeAssistantInterface {
  @override
  Future<HomeAssistantAuth> authenticate({required Uri url}) {
    return canConnectToHomeAssistant(url: url).then((host) {
      throwIf(host == null, HostsNotFound());
      return authenticateHomeAssistant(url: host!);
    });
  }

  Future<HomeAssistantAuth> authenticateHomeAssistant({required Uri url}) {
    const String callbackUrlScheme =
        ApiProprties.homeAssistantAuthcallbackScheme;

    url = url.replace(path: '/auth/authorize', queryParameters: {
      'response_type': ApiProprties.homeAssistantAuthresponseType,
      'client_id': ApiProprties.homeAssistantAuthclientId,
      'redirect_uri': '$callbackUrlScheme:/'
    });

    return FlutterWebAuth.authenticate(
            url: url.toString(), callbackUrlScheme: callbackUrlScheme)
        .then((result) => HomeAssistantAuth(
            token: Uri.parse(result)
                .queryParameters[ApiProprties.homeAssistantAuthresponseType]
                .toString()));
  }

  @override
  StreamSubscription<HostModel> scan({
    required List<String> hosts,
    required void Function(String) onData,
    Function? onError,
  }) {
    return LanScanner()
        .icmpScan(hosts[0],
            firstIP: int.parse(hosts[1]),
            lastIP: int.parse(hosts[2]),
            scanThreads: 8)
        .listen((device) async {
      Uri? possibleHost = await canConnectToHomeAssistant(
          url: Uri(scheme: 'http', host: device.ip, port: 8123));
      if (possibleHost != null) {
        onData(possibleHost.toString());
      }
    }, onError: onError);
  }

  @override
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = timeout;
      await client.get(url.host, url.port, '');
      client.close();
      return url;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<String>> discoverAvailableHosts() async {
    final info = NetworkInfo();

    String? hostIpString = await info.getWifiIP();
    String? hostSubmaskString = await info.getWifiSubmask();

    final ip = hostIpString!.parseIPv4Address();
    final subnet = hostSubmaskString!.parseIPv4Address();

    final network = ip & subnet;
    final firstIp = network + 1;
    final lastIp = (~subnet | firstIp).toUnsigned(firstIp.bitLength);

    final firstParsedIp = IPv4.parse(firstIp);
    final lastParsedIp = IPv4.parse(lastIp);

    return [
      hostIpString.substring(0, hostIpString.lastIndexOf('.')),
      firstParsedIp.substring(
          firstParsedIp.lastIndexOf('.') + 1, firstParsedIp.length),
      lastParsedIp.substring(
          lastParsedIp.lastIndexOf('.') + 1, lastParsedIp.length)
    ];
  }
}
