import 'dart:convert';

import 'package:homsai/crossconcern/utilities/properties/app_preference.proprties.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_preferences.interface.dart';

class AppPreferences implements AppPreferencesInterface {
  SharedPreferences? preferences;

  @override
  Future<void> initialize() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  HomeAssistantAuth? getToken() {
    return HomeAssistantAuth.fromJson(jsonDecode(
        preferences?.getString(AppPreferencesProperties.prefKeyAccessToken) ??
            "{}"));
  }

  @override
  void resetToken() {preferences?.remove(AppPreferencesProperties.prefKeyAccessToken);}

  @override
  void setToken(HomeAssistantAuth token) {
    preferences?.setString(AppPreferencesProperties.prefKeyAccessToken,
        jsonEncode(token));
  }
}
