import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class AppPreferencesInterface {
  Future<void> initialize();

  HomeAssistantAuth? getToken();
  void setToken(HomeAssistantAuth homeAssistantAuth);
  void resetToken();
}
