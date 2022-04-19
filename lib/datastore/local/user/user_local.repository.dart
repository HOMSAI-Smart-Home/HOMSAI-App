import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/main.dart';

import 'user_local.interface.dart';

class UserLocalRepository implements UserLocalInterface {
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  @override
  HomeAssistantAuth? getToken() {
    return appPreferences.getHomeAssistantToken();
  }

  @override
  void setToken(HomeAssistantAuth token) {
    appPreferences.setHomeAssistantToken(token);
  }

  @override
  void resetAccessToken() {
    appPreferences.resetHomeAssistantToken();
  }
}
