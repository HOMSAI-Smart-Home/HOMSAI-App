import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class AppPreferencesInterface {
  Future<void> initialize();

  bool canSkipIntroduction();
  void setIntroduction(bool canSkip);
  void resetIntroduction();

  HomeAssistantAuth? getHomeAssistantToken();
  void setHomeAssistantToken(HomeAssistantAuth homeAssistantAuth);
  void resetHomeAssistantToken();

  AiServiceAuth? getAiServiceToken();
  void setAiServicetToken(AiServiceAuth aiServiceAuth);
  void resetAiServiceToken();

  void resetUserId();
  void setUserId(String id);
  String? getUserId();

  void logout();
}
