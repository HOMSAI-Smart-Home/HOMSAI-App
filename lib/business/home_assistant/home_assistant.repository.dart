import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/crossconcern/exceptions/scanning_not_found.exception.dart';
import 'package:homsai/crossconcern/exceptions/token.exception.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class HomeAssistantRepository implements HomeAssistantInterface {
  final HomeAssistantScannerInterface _homeAssistantScanner =
      getIt.get<HomeAssistantScannerInterface>();

  @override
  Future<HomeAssistantAuth> authenticate({required Uri url}) {
    return canConnectToHomeAssistant(url: url).then((host) {
      throwIf(host == null, HostsNotFound());
      return authenticateHomeAssistant(url: host!);
    });
  }

  Future<HomeAssistantAuth> authenticateHomeAssistant({required Uri url}) {
    const String callbackUrlScheme =
        HomeAssistantApiProprties.authCallbackScheme;

    url =
        url.replace(path: HomeAssistantApiProprties.authPath, queryParameters: {
      'response_type': HomeAssistantApiProprties.authResponseType,
      'client_id': HomeAssistantApiProprties.authClientId,
      'redirect_uri': '$callbackUrlScheme:/'
    });

    return FlutterWebAuth.authenticate(
            url: url.toString(), callbackUrlScheme: callbackUrlScheme)
        .then((result) {
      return _getToken(url: url, result: result);
    });
  }

  @override
  StreamSubscription<String> scan({
    required void Function(String) onData,
    Function? onError,
  }) {
    return _homeAssistantScanner.scanNetwork().listen((host) {
      //TODO: qui il messaggio arriva, va controllato il block, credo..
      print(host);
      onData(host);
    }, onError: onError);
  }

  @override
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    return _homeAssistantScanner.canConnectToHomeAssistant(
        url: url, timeout: timeout);
  }

  Future<HomeAssistantAuth> _getToken(
      {required Uri url,
      required String result,
      Duration timeout = const Duration(seconds: 2)}) async {
    late HttpClient client;
    late Map data;
    late int now;

    String userCode = Uri.parse(result)
        .queryParameters[HomeAssistantApiProprties.authResponseType]
        .toString();

    url = url.replace(
        path: HomeAssistantApiProprties.tokenPath, queryParameters: {});

    client = HttpClient();
    client.connectionTimeout = timeout;

    Map<String, dynamic> body = {
      'grant_type': HomeAssistantApiProprties.tokenGrantType,
      'code': userCode,
      'client_id': HomeAssistantApiProprties.authClientId
    };

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
      throw error as Exception;
    });

    throwIf(response2.statusCode == 400, InvalidRequest);

    data = jsonDecode(response2.body);

    throwIf(data.containsKey("error"),
        InvalidRequest('${data['error']}: ${data['error_description']}'));

    now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return HomeAssistantAuth(
        url.origin,
        data['access_token'],
        now + int.parse(data['expires_in'].toString()),
        data["refresh_token"],
        data["token_type"]);
  }
}
