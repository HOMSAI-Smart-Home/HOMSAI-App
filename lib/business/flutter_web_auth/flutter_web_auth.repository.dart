import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:homsai/business/flutter_web_auth/flutter_web_auth.interface.dart';

class FlutterWebAuthRepository implements FlutterWebAuthInterface {
  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
  }) {
    return FlutterWebAuth.authenticate(
      url: url,
      callbackUrlScheme: callbackUrlScheme,
    );
  }
}
