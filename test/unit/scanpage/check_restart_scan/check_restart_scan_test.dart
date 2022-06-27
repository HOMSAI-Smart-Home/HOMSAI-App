import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/ai_service/ai_service.repository.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.repository.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.repository.dart';
import 'package:homsai/crossconcern/components/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/datastore/remote/rest/remote.repository.dart';
import 'package:homsai/main.dart';
import 'package:homsai/themes/app.theme.dart';
import 'package:homsai/ui/pages/scan/bloc/home_assistant_scan.bloc.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as test;
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

import '../../../util/database/database.dart';
import 'check_restart_scan_test.mocks.dart';

@GenerateMocks([HomeAssistantScannerRepository, NetworkManager])
void main() {
  test.group("HomeAssistantScanPage", () {
    const ipTest = 'http://127.0.0.1';

    flutter_test.setUp(() async {
      MocksHomsaiDatabase.setUp();
    });

    flutter_test.testWidgets(
      'check scanner is restarted when tapped on scan button',
      (flutter_test.WidgetTester tester) async {
        final mockHomeAssistantScanner = MockHomeAssistantScannerRepository();
        final mockNetworkManager = MockNetworkManager();

        WidgetsFlutterBinding.ensureInitialized();

        getIt.registerLazySingleton<AIServiceInterface>(
            () => AIServiceRepository());
        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
        getIt.registerLazySingleton<HomeAssistantInterface>(
            () => HomeAssistantRepository());
        getIt.registerLazySingleton<HomeAssistantScannerInterface>(
            () => mockHomeAssistantScanner);
        getIt.registerLazySingleton<NetworkManagerInterface>(
            () => mockNetworkManager);
        getIt.registerLazySingleton<RemoteInterface>(() => RemoteRepository());

        when(mockHomeAssistantScanner.scanNetwork(
                timeout: argThat(test.anything, named: 'timeout')))
            .thenAnswer((realInvocation) => Stream.fromIterable([ipTest]));
        when(mockNetworkManager.getConnectionType())
            .thenAnswer((realInvocation) async => ConnectivityResult.wifi);

        final doubleUrlBloc = DoubleUrlBloc();
        final bloc = HomeAssistantScanBloc(
          doubleUrlBloc,
          initialState: const HomeAssistantScanState(
            status: HomeAssistantScanStatus.manual,
          ),
        );

        await tester.pumpWidget(MaterialApp(
          title: "scanpage",
          theme: HomsaiThemeData.lightThemeData,
          localizationsDelegates: const [
            ...HomsaiLocalizations.localizationsDelegates,
            LocaleNamesLocalizationsDelegate()
          ],
          supportedLocales: HomsaiLocalizations.supportedLocales,
          home: HomeAssistantScanPage(
            onResult: ((p0) => true),
            doubleUrlBloc: doubleUrlBloc,
            scanBloc: bloc,
          ),
          initialRoute: "/",
        ));
        await tester.pumpAndSettle();

        flutter_test.Finder finder = flutter_test.find.byType(OutlinedButton);
        await tester.ensureVisible(finder);
        await tester.tap(finder);
        await tester.pump(const Duration(seconds: 3));
        flutter_test.expect(
          flutter_test.find.textContaining(
            ipTest,
            findRichText: true,
          ),
          flutter_test.findsOneWidget,
        );
      },
    );

    test.test(
      'check that it returns the found host',
      () async {
        final mockHomeAssistantScanner = MockHomeAssistantScannerRepository();
        final mockNetworkManager = MockNetworkManager();

        WidgetsFlutterBinding.ensureInitialized();

        getIt.registerLazySingleton<AIServiceInterface>(
            () => AIServiceRepository());
        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
        getIt.registerLazySingleton<HomeAssistantInterface>(
            () => HomeAssistantRepository());
        getIt.registerLazySingleton<HomeAssistantScannerInterface>(
            () => mockHomeAssistantScanner);
        getIt.registerLazySingleton<NetworkManagerInterface>(
            () => mockNetworkManager);
        getIt.registerLazySingleton<RemoteInterface>(() => RemoteRepository());

        when(mockHomeAssistantScanner.scanNetwork(
                timeout: argThat(test.anything, named: 'timeout')))
            .thenAnswer((realInvocation) => Stream.fromIterable([ipTest]));
        when(mockNetworkManager.getConnectionType())
            .thenAnswer((realInvocation) async => ConnectivityResult.wifi);

        final bloc = HomeAssistantScanBloc(
          DoubleUrlBloc(),
          initialState: const HomeAssistantScanState(
            status: HomeAssistantScanStatus.manual,
          ),
        );

        bloc.add(const ScanPressed());

        await test.expectLater(
          bloc.stream,
          test.emits(test.emitsInOrder([
            test.isA<HomeAssistantScanState>(),
            test.isA<HomeAssistantScanState>(),
          ])),
        );
        test.expect(bloc.state.scannedUrls, test.isNotEmpty);
      },
    );
  });
}
