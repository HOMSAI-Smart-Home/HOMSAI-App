import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

abstract class UserLocalInterface {
  HomeAssistantAuth? getToken();
  void resetAccessToken();
  void setToken(HomeAssistantAuth token);
}
