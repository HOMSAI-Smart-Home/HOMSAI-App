import 'package:homsai/datastore/models/home_assistant_auth.model.dart';

import '../../../main.dart';
import '../apppreferences/app_preferences.interface.dart';
import 'user_local.interface.dart';

class UserLocalRepository implements UserLocalInterface {
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  @override
  HomeAssistantAuth? getToken() {
    return appPreferences.getToken();
  }

  @override
  void setToken(HomeAssistantAuth token) {
    appPreferences.setToken(token);
  }

  @override
  void resetAccessToken() {
    appPreferences.resetToken();
  }
}
