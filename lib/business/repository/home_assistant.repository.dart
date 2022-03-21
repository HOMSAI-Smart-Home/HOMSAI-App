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
    List<String> hostInfo =
        url.replaceAll("http://", "").replaceAll("https://", "").split(":");
    int port = 8123;
    if (hostInfo.length > 1) {
      port = int.parse(hostInfo[1]);
    }

    return canConnectToHomeAssistant(host: hostInfo.first, port: port)
        .then((host) {
      throwIf(host == null, HostsNotFound());
      return authenticateHomeAssistant(url: host! + ":$port");
    });
  }

  Future<HomeAssistantAuth> authenticateHomeAssistant({required String url}) {
    const String callbackUrlScheme =
        ApiProprties.homeAssistantAuthcallbackScheme;
    final String uri = Uri.https(url, '/auth/authorize', {
      'response_type': ApiProprties.homeAssistantAuthresponseType,
      'client_id': ApiProprties.homeAssistantAuthclientId,
      'redirect_uri': '$callbackUrlScheme:/',
    }).toString();

    return FlutterWebAuth.authenticate(
            url: uri, callbackUrlScheme: callbackUrlScheme)
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
          .flatMap(
              (device) => canConnectToHomeAssistant(host: device.ip).asStream())
          .fold([], (previous, element) {
        if (element != null) {
          previous.add("http://" + element + ":8123");
        }
        return previous;
      });
    });
  }

  @override
  Future<String?> canConnectToHomeAssistant({
    required String host,
    int port = 8123,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    try {
      final client = HttpClient();
      client.connectionTimeout = timeout;
      await client.get(host, port, '');
      client.close();
      return host;
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
