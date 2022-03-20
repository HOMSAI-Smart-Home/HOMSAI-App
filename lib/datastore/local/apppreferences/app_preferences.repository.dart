import 'package:homsai/crossconcern/utilities/properties/app_preference.proprties.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.interface.dart';

class AppPreferences implements AppPreferencesInterface {
  SharedPreferences? preferences;

  @override
  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  String? getAccessToken() {
    return preferences
        ?.getString(AppPreferencesProperties.PREF_KEY_ACCESS_TOKEN);
  }

  @override
  void setAccessToken(String value) {
    preferences?.setString(
        AppPreferencesProperties.PREF_KEY_ACCESS_TOKEN, value);
  }

  @override
  void resetAccessToken() {
    preferences?.remove(AppPreferencesProperties.PREF_KEY_ACCESS_TOKEN);
  }
}
