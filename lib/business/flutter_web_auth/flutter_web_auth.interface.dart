abstract class FlutterWebAuthInterface {
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
  });
}
