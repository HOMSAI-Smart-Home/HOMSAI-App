import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.repository.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.repository.dart';
import 'package:homsai/business/light/light.interface.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/datastore/remote/rest/remote.repository.dart';
import 'package:homsai/crossconcern/utilities/properties/database.properties.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant.broker.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/business/light/light.repository.dart';
import 'package:homsai/crossconcern/utilities/properties/constants.util.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/local/user/user_local.interface.dart';
import 'package:homsai/datastore/local/user/user_local.repository.dart';
import 'package:homsai/app.router.dart';
import 'package:homsai/themes/app.theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

final getIt = GetIt.instance;
String? appVersion;

Future<void> setup() async {
  // It enables to reassign an implementation of an interface, for example in Unit tests
  getIt.allowReassignment = true;

  // Local interfaces
  final database =
      await $FloorAppDatabase.databaseBuilder(DatabaseProperties.name).build();
  getIt.registerLazySingleton<AppDatabase>(() => database);
  // Wait asynchronous AppPreferences initialization
  final AppPreferencesInterface appPreferences = AppPreferences();
  await appPreferences.initialize();
  getIt.registerLazySingleton<AppPreferencesInterface>(() => appPreferences);
  getIt.registerLazySingleton<UserLocalInterface>(() => UserLocalRepository());
  getIt.registerLazySingleton<NetworkManagerInterface>(() => NetworkManager());

  // Remote interfaces
  getIt.registerLazySingleton<HomeAssistantScannerInterface>(
      () => HomeAssistantScannerRepository());

  getIt.registerLazySingleton<HomeAssistantInterface>(
      () => HomeAssistantRepository());

  getIt.registerLazySingleton<HomeAssistantWebSocketRepository>(
      () => HomeAssistantWebSocketRepository());

  getIt.registerLazySingleton<HomeAssistantBroker>(() => HomeAssistantBroker());

  getIt
      .registerLazySingleton<LightRepositoryInterface>(() => LightRepository());

  getIt.registerLazySingleton<RemoteInterface>(() => RemoteRepository());
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize singletons
  await setup();

  getAppVersion();

  Timer(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
  });

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(App());
}

void getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.appName + "-" + packageInfo.version;
}

class App extends StatelessWidget {
  final _appRouter = AppRouter(authGuard: AuthGuard());

  App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: true,
      title: appName,
      theme: HomsaiThemeData.lightThemeData,
      localizationsDelegates: const [
        ...HomsaiLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate()
      ],
      supportedLocales: HomsaiLocalizations.supportedLocales,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
