import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:homsai/business/interfaces/home_assistant.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

class HomeAssistantRepository implements HomeAssistantInterface {
  @override
  Future<HomeAssistantAuth> authenticate({required String url}) {
    const String clientId = 'http://authcallback.homsai.app';
    const String callbackUrlScheme = 'homsai';
    final String uri = Uri.http(url, '/auth/authorize', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': '$callbackUrlScheme:/',
    }).toString();

    return FlutterWebAuth.authenticate(
            url: uri, callbackUrlScheme: callbackUrlScheme)
        .then((result) => HomeAssistantAuth(
            token: Uri.parse(result).queryParameters['code'].toString()));
  }
}
