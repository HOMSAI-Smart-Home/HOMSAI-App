import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/crossconcern/exceptions/scanning_not_found.exception.dart';
import 'package:homsai/crossconcern/exceptions/token.exception.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/main.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class HomeAssistantRepository implements HomeAssistantInterface {
  final HomeAssistantScannerInterface _homeAssistantScanner =
      getIt.get<HomeAssistantScannerInterface>();

  final NetworkManagerInterface networkManager =
      getIt.get<NetworkManagerInterface>();

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
  Future<StreamSubscription<String>> scan({
    required void Function(String) onData,
    Function? onError,
  }) async {
    throwIf(
      await networkManager.getConnectionType() != ConnectivityResult.wifi,
      Exception("Wifi Disabled"),
    );

    return _homeAssistantScanner.scanNetwork().listen(onData, onError: onError);
  }

  @override
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    return _homeAssistantScanner.canConnectToHomeAssistant(
        url: url, timeout: timeout);
  }

  Future<Map<String, dynamic>> _getReqest(
      Duration timeout, Uri url, Map<String, dynamic> body) async {
    Map<String, dynamic> data = {};
    Response response;
    HttpClient client = HttpClient();
    client.connectionTimeout = timeout;

    url = url.replace(
      path: HomeAssistantApiProprties.tokenPath,
      queryParameters: {},
    );

    response = await http
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

    try {
      data = jsonDecode(response.body);
      print(data);
      throwIf(data.containsKey("error"),
          InvalidRequest('${data['error']}: ${data['error_description']}'));
    } catch (e) {
      rethrow;
    }

    return data;
  }

  Future<HomeAssistantAuth> _getToken(
      {required Uri url,
      required String result,
      Duration timeout = const Duration(seconds: 2)}) async {
    Map<String, dynamic> data;
    Map<String, dynamic> body;
    int now;

    String userCode = Uri.parse(result)
        .queryParameters[HomeAssistantApiProprties.authResponseType]
        .toString();

    body = {
      'grant_type': HomeAssistantApiProprties.tokenGrantType,
      'code': userCode,
      'client_id': HomeAssistantApiProprties.authClientId
    };

    data = await _getReqest(timeout, url, body);

    now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print({
      "expires": int.parse(data['expires_in'].toString()),
      "now": now,
      "tot": now + 30
    });

    return HomeAssistantAuth(
        url.origin,
        data['access_token'],
        //now + int.parse(data['expires_in'].toString()),
        now + 30,
        data["refresh_token"],
        data["token_type"]);
  }

  @override
  Future refreshToken({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final AppPreferencesInterface appPreferencesInterface =
        getIt.get<AppPreferencesInterface>();
    HomeAssistantAuth? auth = appPreferencesInterface.getToken();
    Map<String, dynamic> body;
    Map<String, dynamic> data;
    int now;

    url = url.replace(
        path: HomeAssistantApiProprties.tokenPath, queryParameters: {});

    body = {
      'grant_type': HomeAssistantApiProprties.tokenRefresh,
      'refresh_token': auth!.refreshToken,
      'client_id': HomeAssistantApiProprties.authClientId,
    };

    data = await _getReqest(timeout, url, body);

    now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print({
      "expires": int.parse(data['expires_in'].toString()),
      "now": now,
      "tot": now + 30
    });

    auth.token = data["access_token"];
    //auth.expires = now + int.parse(data['expires_in'].toString());
    auth.expires = now + 30;
    auth.tokenType = data["token_type"];

    print(auth);
  }

  @override
  Future revokeToken({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    HomeAssistantAuth auth = getIt.get<HomeAssistantAuth>();
    Map<String, dynamic> body;
    Map<String, dynamic> data;
    int now;

    url = url.replace(
        path: HomeAssistantApiProprties.tokenPath, queryParameters: {});

    body = {
      'action': HomeAssistantApiProprties.tokenRevoke,
      'token': auth.token,
    };

    data = await _getReqest(timeout, url, body);

    now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    print("refresh");

    auth.token = data["refresh_token"];
    auth.expires = now + int.parse(data['expires_in'].toString());
    auth.tokenType = data["token_type"];
  }
}
