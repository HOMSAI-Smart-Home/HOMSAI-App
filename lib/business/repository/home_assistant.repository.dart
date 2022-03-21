import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/interfaces/home_assistant.interface.dart';
import 'package:homsai/crossconcern/exceptions/scanning_not_found.exception.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:rxdart/rxdart.dart';

class HomeAssistantRepository implements HomeAssistantInterface {
  @override
  Future<HomeAssistantAuth> authenticate({required String url}) {
    List<String> hostInfo = url.split("://");

    int port = 8123;
    if (hostInfo[1].split(':').length > 1) {
      port = int.parse(hostInfo[1].split(':')[1]);
      hostInfo[1] = hostInfo[1].split(':')[0];
    }

    Uri UriUrl = Uri(scheme: hostInfo[0], host: hostInfo[1], port: port);

    return canConnectToHomeAssistant(url: UriUrl).then((host) {
      throwIf(host == null, HostsNotFound());
      return authenticateHomeAssistant(url: host!);
    });
  }

  Future<HomeAssistantAuth> authenticateHomeAssistant({required Uri url}) {
    const String callbackUrlScheme =
        ApiProprties.homeAssistantAuthcallbackScheme;
    url.replace(path: '/auth/authorize', queryParameters: {
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
  Future<List<String>> startScan({
    void Function(double)? progressCallback,
  }) async {
    return _discoverAvailableHosts().then((hosts) {
      return LanScanner()
          .icmpScan(hosts[0],
              firstIP: int.parse(hosts[1]),
              lastIP: int.parse(hosts[2]),
              scanThreads: 8,
              progressCallback: progressCallback)
          .flatMap((device) => canConnectToHomeAssistant(
                  url: Uri(scheme: 'http', host: device.ip, port: 8123))
              .asStream())
          .fold([], (previous, element) {
        if (element != null) {
          previous.add(element.toString());
        }
        return previous;
      });
    });
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

  Future<List<String>> _discoverAvailableHosts() async {
    int ipToint(String ip) {
      List<String> ipList = ip.split('.');
      return ipList.asMap().entries.map((entry) {
        return int.parse(entry.value) * pow(256, ipList.length - entry.key - 1);
      }).reduce((prev, curr) {
        return prev + curr;
      }).toInt();
    }

    int getNetwork(int ip, int subnet) {
      return ip & subnet;
    }

    String intToIp(int value) {
      Uint8List int32bytes(int value) =>
          Uint8List(4)..buffer.asInt32List()[0] = value;

      return int32bytes(value).reversed.toList().join('.');
    }

    final info = NetworkInfo();
    late int ip;
    late int subnet;

    late int network;
    late int firstIp;
    late int lastIp;

    String? hostIpString = await info.getWifiIP();
    String? hostSubmaskString = await info.getWifiSubmask();

    ip = ipToint(hostIpString!);
    subnet = ipToint(hostSubmaskString!);

    network = getNetwork(ip, subnet);
    firstIp = network + 1;
    lastIp = (~subnet | firstIp).toUnsigned(firstIp.bitLength);

    return [
      hostIpString.substring(0, hostIpString.lastIndexOf('.')),
      intToIp(firstIp).substring(
          intToIp(firstIp).lastIndexOf('.') + 1, intToIp(firstIp).length),
      intToIp(lastIp).substring(
          intToIp(lastIp).lastIndexOf('.') + 1, intToIp(lastIp).length)
    ];
  }
}
