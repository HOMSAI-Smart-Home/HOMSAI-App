import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/interfaces/home_assistant.interface.dart';
import 'package:homsai/crossconcern/exceptions/scanning_not_found.exception.dart';
import 'package:homsai/crossconcern/exceptions/token.exception.dart';
import 'package:homsai/crossconcern/helpers/extensions/ipv4.extension.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:http/http.dart';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:http/http.dart' as http;

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

    url =
        url.replace(path: ApiProprties.homeAssistantAuthPath, queryParameters: {
      'response_type': ApiProprties.homeAssistantAuthresponseType,
      'client_id': ApiProprties.homeAssistantAuthclientId,
      'redirect_uri': '$callbackUrlScheme:/'
    });

    return FlutterWebAuth.authenticate(
            url: url.toString(), callbackUrlScheme: callbackUrlScheme)
        .then((result) {
      return _getToken(url: url, result: result);
    });
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
            scanThreads: 20)
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
      HttpClient client = HttpClient();
      client.connectionTimeout = timeout;
      await client.get(url.host, url.port, url.path);
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

  Future<HomeAssistantAuth> _getToken(
      {required Uri url,
      required String result,
      Duration timeout = const Duration(seconds: 2)}) async {
    late HttpClient client;
    late HttpClientResponse response;
    late Map data;
    late int now;

    String userCode = Uri.parse(result)
        .queryParameters[ApiProprties.homeAssistantAuthresponseType]
        .toString();

    url = url.replace(
        path: ApiProprties.homeAssistantTokenPath, queryParameters: {});

    client = HttpClient();
    client.connectionTimeout = timeout;

    //HttpClientRequest request = await client.post(url.host, url.port, url.path);
    Map<String, dynamic> body = {
      'grant_type': ApiProprties.homeAssistantTokenGrantType,
      'code': userCode,
      'client_id': ApiProprties.homeAssistantAuthclientId
    };
    //request.encoding = Encoding.getByName('application/x-www-form-urlencoded')!;
    /*request.encoding = Ut;
    request.headers.set(
        HttpHeaders.contentTypeHeader, "application/x-www_form-urlencoded");
    request.write(body);
    response = await request.close();*/
    Response response2 = await http
        .post(
          url,
          body: body,
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          },
          encoding: Encoding.getByName('utf-8'),
        )
        .timeout(timeout)
        .onError((error, stackTrace) {
      print(error);
      throw error as Exception;
    });

    throwIf(response2.statusCode == 400, InvalidRequest);

    data = jsonDecode(response2.body);

    throwIf(data.containsKey("error"),
        InvalidRequest('${data['error']}: ${data['error_description']}'));

    now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return HomeAssistantAuth(
        data['access_token'],
        now + int.parse(data['expires_in'].toString()),
        data["refresh_token"],
        data["token_type"]);
  }
}
