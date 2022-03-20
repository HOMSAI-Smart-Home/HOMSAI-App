abstract class AppPreferencesInterface {
  Future<void> initialize();

  String? getAccessToken();
  void setAccessToken(String value);
  void resetAccessToken();
}
