import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/ai_service/ai_service.repository.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.repository.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.repository.dart';
import 'package:homsai/business/light/light.interface.dart';
import 'package:homsai/datastore/models/home_assistant_auth.model.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/datastore/remote/rest/remote.repository.dart';
import 'package:homsai/crossconcern/utilities/properties/database.properties.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant.broker.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
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
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final getIt = GetIt.instance;
String? appVersion;

Future<void> setup() async {
  // It enables to reassign an implementation of an interface, for example in Unit tests
  getIt.allowReassignment = true;

  // Wait asynchronous AppPreferences initialization
  final AppPreferencesInterface appPreferences = AppPreferences();
  await appPreferences.initialize();
  getIt.registerLazySingleton<AppPreferencesInterface>(() => appPreferences);
  // Local interfaces
  final database =
      await $FloorAppDatabase.databaseBuilder(DatabaseProperties.name).build();
  getIt.registerLazySingleton<AppDatabase>(() => database);
  getIt.registerLazySingleton<UserLocalInterface>(() => UserLocalRepository());
  getIt.registerLazySingleton<NetworkManagerInterface>(() => NetworkManager());

  // Remote interfaces
  getIt.registerLazySingleton<HomeAssistantScannerInterface>(
      () => HomeAssistantScannerRepository());

  getIt.registerLazySingleton<HomeAssistantInterface>(
      () => HomeAssistantRepository());

  getIt.registerLazySingleton<AIServiceInterface>(() => AIServiceRepository());

  getIt.registerLazySingleton<HomeAssistantWebSocketInterface>(
      () => HomeAssistantWebSocketRepository());

  getIt.registerLazySingleton<HomeAssistantBroker>(() => HomeAssistantBroker());

  getIt
      .registerLazySingleton<LightRepositoryInterface>(() => LightRepository());

  getIt.registerLazySingleton<RemoteInterface>(() => RemoteRepository());

  getIt.registerLazySingleton<AIServiceInterface>(() => AIServiceRepository());
}

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize singletons
  await setup();

  getAppVersion();

  Timer(const Duration(seconds: 3), () {
    FlutterNativeSplash.remove();
  });

  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  tz.initializeTimeZones();

  runApp(const App());
}

void getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.appName + "-" + packageInfo.version;
}

class App extends StatefulWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final HomeAssistantWebSocketInterface _webSocketInterface =
      getIt.get<HomeAssistantWebSocketInterface>();
  final AppPreferencesInterface _appPreferencesInterface =
      getIt.get<AppPreferencesInterface>();
  final _appRouter = AppRouter(authGuard: AuthGuard());

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _logout();
    super.dispose();
  }

  void _logout() {
    if (_webSocketInterface.isConnected() ||
        _webSocketInterface.isConnecting()) {
      _webSocketInterface.logout();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          HomeAssistantAuth? auth =
              _appPreferencesInterface.getHomeAssistantToken();
          String? userId = _appPreferencesInterface.getUserId();
          if (userId != null && auth != null) {
            if (!_webSocketInterface.isConnected() &&
                !_webSocketInterface.isConnecting()) {
              _webSocketInterface.connect();
            }
          }
          break;
        case AppLifecycleState.inactive:
          break;
        case AppLifecycleState.paused:
          _logout();
          break;
        case AppLifecycleState.detached:
          break;
      }
    });
  }

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
