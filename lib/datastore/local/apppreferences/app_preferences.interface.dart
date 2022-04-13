import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class AppPreferencesInterface {
  Future<void> initialize();

  bool canSkipIntroduction();
  void setIntroduction(bool canSkip);
  void resetIntroduction();

  HomeAssistantAuth? getToken();
  void setToken(HomeAssistantAuth homeAssistantAuth);
  void resetToken();

  void resetUserId();
  void setUserId(int id);
  int? getUserId();
}
