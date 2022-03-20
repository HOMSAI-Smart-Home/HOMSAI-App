import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/interfaces/home_assistant.interface.dart';
import 'package:homsai/business/repository/home_assistant.repository.dart';
import 'package:homsai/crossconcern/utilities/properties/constants.util.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/local/user/user_local.interface.dart';
import 'package:homsai/datastore/local/user/user_local.repository.dart';
import 'package:homsai/routes.dart';
import 'package:homsai/themes/app.theme.dart';

final getIt = GetIt.instance;

void setup() {
  // It enables to reassign an implementation of an interface, for example in Unit tests
  getIt.allowReassignment = true;

  // Local interfaces
  getIt.registerLazySingleton<AppPreferencesInterface>(() => AppPreferences());
  getIt.registerLazySingleton<UserLocalInterface>(() => UserLocalRepository());

  getIt.registerLazySingleton<HomeAssistantInterface>(
      () => HomeAssistantRepository());
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize singletons
  setup();

// Wait asynchronous AppPreferences initialization
  final AppPreferencesInterface appPreferences =
      getIt.get<AppPreferencesInterface>();
  await appPreferences.initialize();

  Timer(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
  });
  runApp(const HomsaiApp());
}

class HomsaiApp extends StatelessWidget {
  const HomsaiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: appName,
      theme: HomsaiThemeData.lightThemeData,
      localizationsDelegates: const [
        ...HomsaiLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate()
      ],
      supportedLocales: HomsaiLocalizations.supportedLocales,
      initialRoute: RouteConfiguration.initialRoute,
      onGenerateRoute: RouteConfiguration.onGenerateRoute,
    );
  }
}
