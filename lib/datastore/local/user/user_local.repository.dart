import '../../../main.dart';
import '../apppreferences/app_preferences.interface.dart';
import 'user_local.interface.dart';

class UserLocalRepository implements UserLocalInterface {
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();

  @override
  String? getAccessToken() {
    return appPreferences.getAccessToken();
  }

  @override
  void setAccessToken(String token) {
    appPreferences.setAccessToken(token);
  }

  @override
  void resetAccessToken() {
    appPreferences.resetAccessToken();
  }
}
