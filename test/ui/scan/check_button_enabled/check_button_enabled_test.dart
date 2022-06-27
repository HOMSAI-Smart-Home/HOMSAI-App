import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.repository.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.repository.dart';
import 'package:homsai/crossconcern/components/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';
import 'package:homsai/themes/app.theme.dart';
import 'package:homsai/ui/pages/scan/bloc/home_assistant_scan.bloc.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as test;
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

import '../../../util/ai_service/ai_service.dart';
import '../../../util/apppreferences/app_preferences.dart';
import 'check_button_enabled_test.mocks.dart';

@GenerateMocks(
    [HomeAssistantScannerRepository, NetworkManager, RemoteInterface])
void main() {
  test.group("HomeAssistantScanPage", () {
    const ipTest = 'http://127.0.0.1';

    late MockHomeAssistantScannerRepository mockHomeAssistantScanner;
    late MockNetworkManager mockNetworkManager;

    flutter_test.setUp(() async {
      WidgetsFlutterBinding.ensureInitialized();
      //tz.initializeTimeZones();

      MocksAIService.setUp();
      await MocksAppPreferences.setUp();
      getIt.registerLazySingleton<HomeAssistantInterface>(
          () => HomeAssistantRepository());
      getIt.registerLazySingleton<RemoteInterface>(() => MockRemoteInterface());

      mockHomeAssistantScanner = MockHomeAssistantScannerRepository();
      mockNetworkManager = MockNetworkManager();

      getIt.registerLazySingleton<HomeAssistantScannerInterface>(
          () => mockHomeAssistantScanner);
      getIt.registerLazySingleton<NetworkManagerInterface>(
          () => mockNetworkManager);
    });

    flutter_test.testWidgets(
      'check scanner is restarted when tapped on scan button',
      (flutter_test.WidgetTester tester) async {
        when(mockHomeAssistantScanner.scanNetwork(
                timeout: argThat(test.anything, named: 'timeout')))
            .thenAnswer((realInvocation) => Stream.fromIterable([ipTest]));
        when(mockNetworkManager.getConnectionType())
            .thenAnswer((realInvocation) async => ConnectivityResult.wifi);

        final doubleUrlBloc = DoubleUrlBloc();
        final bloc = HomeAssistantScanBloc(doubleUrlBloc);

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

        final card = flutter_test.find.textContaining(
          ipTest,
          findRichText: true,
        );
        final button = flutter_test.find.byType(ElevatedButton).last;

        await tester.ensureVisible(card);
        flutter_test.expect(
          card,
          flutter_test.findsOneWidget,
        );

        await tester.ensureVisible(button);
        flutter_test.expect(
          button,
          flutter_test.findsOneWidget,
        );
        flutter_test.expect(
          tester.widget<ElevatedButton>(button).enabled,
          false,
        );

        await tester.tap(card);
        await tester.pumpAndSettle();

        await tester.ensureVisible(button);
        flutter_test.expect(
          button,
          flutter_test.findsOneWidget,
        );
        flutter_test.expect(
          tester.widget<ElevatedButton>(button).enabled,
          true,
        );
      },
    );
  });
}
