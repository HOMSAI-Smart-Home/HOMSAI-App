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
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart';
import 'package:homsai/datastore/DTOs/remote/logbook/logbook.dto.dart';
import 'package:homsai/datastore/DTOs/remote/logbook/logbook_body.dto.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';

class HomeAssistantRepository implements HomeAssistantInterface {
  final HomeAssistantScannerInterface _homeAssistantScanner =
      getIt.get<HomeAssistantScannerInterface>();

  final NetworkManagerInterface networkManager =
      getIt.get<NetworkManagerInterface>();

  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  final RemoteInterface remote = getIt.get<RemoteInterface>();

  @override
  Future<HomeAssistantAuth> authenticate(
      {required Uri url, required bool remote}) {
    return canConnectToHomeAssistant(url: url).then((host) {
      throwIf(host == null, HostsNotFound());
      return authenticateHomeAssistant(url: host!, remote: remote);
    });
  }

  Map<String, String> _getHeader() {
    final headers = {HttpHeaders.acceptHeader: 'application/json'};

    final HomeAssistantAuth? token = appPreferences.getHomeAssistantToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer ' + token.token;
    }

    return headers;
  }

  Future<HomeAssistantAuth> authenticateHomeAssistant(
      {required Uri url, required bool remote}) {
    const String callbackUrlScheme =
        HomeAssistantApiProprties.authCallbackScheme;

    url = url.replace(
      path: HomeAssistantApiProprties.authPath,
      queryParameters: {
        'response_type': HomeAssistantApiProprties.authResponseType,
        'client_id': HomeAssistantApiProprties.authClientId,
        'redirect_uri': '$callbackUrlScheme:/'
      },
    );

    return FlutterWebAuth.authenticate(
      url: url.toString(),
      callbackUrlScheme: callbackUrlScheme,
    ).then((result) {
      return _getToken(url: url, result: result, remote: remote);
    });
  }

  @override
  Future<StreamSubscription<String>> scan({
    required void Function(String) onData,
    Function? onError,
    Duration? timeout,
  }) async {
    throwIf(
      await networkManager.getConnectionType() != ConnectivityResult.wifi,
      Exception("Wifi Disabled"),
    );

    return _homeAssistantScanner
        .scanNetwork(timeout: timeout ?? const Duration(seconds: 3))
        .listen(onData, onError: onError);
  }

  @override
  Future<Uri?> canConnectToHomeAssistant({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    return _homeAssistantScanner.canConnectToHomeAssistant(
        url: url, timeout: timeout);
  }

  Future<Map<String, dynamic>> _tokenReqest({
    required Duration timeout,
    required Uri baseurl,
    Uri? fallback,
    required Map<String, dynamic> body,
  }) async {
    Map<String, dynamic> response = {};
    HttpClient client = HttpClient();
    client.connectionTimeout = timeout;

    baseurl = baseurl.replace(
      path: HomeAssistantApiProprties.tokenPath,
      queryParameters: {},
    );
    fallback = fallback?.replace(
      path: HomeAssistantApiProprties.tokenPath,
      queryParameters: {},
    );

    response = await remote.post(
      baseurl,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body,
      encoding: Encoding.getByName('utf-8'),
      fallbackUrl: fallback,
      timeout: timeout,
    );

    throwIf(
      response.containsKey("error"),
      InvalidRequest(
          message: '${response['error']}: ${response['error_description']}'),
    );

    return response;
  }

  Future<HomeAssistantAuth> _getToken({
    required Uri url,
    required String result,
    required bool remote,
    Duration timeout = const Duration(seconds: 2),
  }) async {
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

    data = await _tokenReqest(timeout: timeout, baseurl: url, body: body);

    now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    return HomeAssistantAuth(
        data['access_token'],
        now + int.parse(data['expires_in'].toString()),
        data["refresh_token"],
        data["token_type"]);
  }

  @override
  Future<HomeAssistantAuth> refreshToken({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    HomeAssistantAuth? auth = appPreferences.getHomeAssistantToken();
    Map<String, dynamic> body;
    Map<String, dynamic> data;
    int now;

    url = url.replace(
      path: HomeAssistantApiProprties.tokenPath,
      queryParameters: {},
    );

    body = {
      'grant_type': HomeAssistantApiProprties.tokenRefresh,
      'refresh_token': auth!.refreshToken,
      'client_id': HomeAssistantApiProprties.authClientId,
    };

    data = await _tokenReqest(
      timeout: timeout,
      baseurl: url,
      body: body,
    );

    now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    auth.token = data["access_token"];
    auth.expires = now + int.parse(data['expires_in'].toString());
    auth.tokenType = data["token_type"];
    return auth;
  }

  @override
  Future revokeToken({
    required Uri url,
    Duration timeout = const Duration(seconds: 2),
  }) async {
    HomeAssistantAuth? auth = appPreferences.getHomeAssistantToken();
    Map<String, dynamic> body;

    url = url.replace(
      path: HomeAssistantApiProprties.tokenPath,
      queryParameters: {},
    );

    body = {
      'action': HomeAssistantApiProprties.tokenRevoke,
      'token': auth!.token,
    };

    await _tokenReqest(
      timeout: timeout,
      baseurl: url,
      body: body,
    );
    appPreferences.resetHomeAssistantToken();
  }

  @override
  Future<List<HistoryDto>> getHistory({
    required Plant plant,
    HistoryBodyDto? historyBodyDto,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    Map<String, dynamic> response;

    final baseUrl = plant.getBaseUrl().replace(
          path: HomeAssistantApiProprties.historyPath +
              "/${historyBodyDto?.start?.toIso8601String() ?? ""}",
          queryParameters: historyBodyDto?.toJson(),
        );
    final fallback = plant.getFallbackUrl()?.replace(
          path: HomeAssistantApiProprties.historyPath +
              "/${historyBodyDto?.start?.toIso8601String() ?? ""}",
          queryParameters: historyBodyDto?.toJson(),
        );

    response = await remote.get(
      baseUrl,
      headers: _getHeader(),
      fallbackUrl: fallback,
      timeout: timeout,
    );

    print(response);
    final history = HistoryDto.fromList(response["data"][0]);
    return history;
  }

  @override
  Future<LogbookDto> getLogBook({
    required Plant plant,
    LogbookBodyDto? logbookBodyDto,
  }) async {
    Map<String, dynamic> response;

    final baseUrl = plant.getBaseUrl().replace(
          path: HomeAssistantApiProprties.logbookPath +
              (logbookBodyDto?.start?.toIso8601String() ?? ""),
          queryParameters: logbookBodyDto?.toJson(),
        );
    final fallback = plant.getFallbackUrl()?.replace(
          path: HomeAssistantApiProprties.logbookPath +
              (logbookBodyDto?.start?.toIso8601String() ?? ""),
          queryParameters: logbookBodyDto?.toJson(),
        );

    response = await remote.get(
      baseUrl,
      headers: _getHeader(),
      fallbackUrl: fallback,
    );

    return LogbookDto.fromJson(response);
  }
}
