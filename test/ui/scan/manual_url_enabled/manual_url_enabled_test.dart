import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/ai_service/ai_service.repository.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.repository.dart';
import 'package:homsai/crossconcern/components/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/main.dart';
import 'package:homsai/themes/app.theme.dart';
import 'package:homsai/ui/pages/intro_beta/bloc/intro_beta.bloc.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:homsai/ui/pages/scan/bloc/home_assistant_scan.bloc.dart';
import 'package:homsai/ui/pages/scan/home_assistant_scan.page.dart';
import 'package:mockito/annotations.dart';

import 'manual_url_enabled_test.mocks.dart';

class MockIntroBetaBloc extends MockBloc<IntroBetaEvent, IntroBetaState>
    implements IntroBetaBloc {}

@GenerateMocks([AIServiceRepository, HomsaiDatabase, HomeAssistantRepository])
void main() {
  group("HomeAssistantScanPage", () {
    testWidgets('should enable button if written url is valid',
        (WidgetTester tester) async {
      await testConinueButtonWithUrl(tester, "http://192.168.1.168:8123", true);
    });

    testWidgets('should disable button if written url is invalid',
        (WidgetTester tester) async {
      await testConinueButtonWithUrl(
          tester, "htt://256.123.123.123:1212", false);
    });
  });
}

testConinueButtonWithUrl(WidgetTester tester, String url, bool isValid) async {
  final MockAIServiceRepository mockAIServiceRepository =
      MockAIServiceRepository();
  final MockHomsaiDatabase mockHomsaiDatabase = MockHomsaiDatabase();
  final MockHomeAssistantRepository mockHomeAssistantRepository =
      MockHomeAssistantRepository();

  // It enables to reassign an implementation of an interface, for example in Unit tests
  getIt.allowReassignment = true;
  getIt
      .registerLazySingleton<AIServiceInterface>(() => mockAIServiceRepository);
  getIt.registerLazySingleton<AppPreferencesInterface>(() => AppPreferences());
  getIt.registerLazySingleton<HomsaiDatabase>(() => mockHomsaiDatabase);
  getIt.registerLazySingleton<HomeAssistantInterface>(
      () => mockHomeAssistantRepository);

  final urlBloc = DoubleUrlBloc();
  const initialState = HomeAssistantScanState(
    status: HomeAssistantScanStatus.manual,
  );
  final bloc = HomeAssistantScanBloc(urlBloc, state: initialState);

  await tester.pumpWidget(MaterialApp(
    title: "scanBloc",
    theme: HomsaiThemeData.lightThemeData,
    localizationsDelegates: const [
      ...HomsaiLocalizations.localizationsDelegates,
      LocaleNamesLocalizationsDelegate()
    ],
    supportedLocales: HomsaiLocalizations.supportedLocales,
    home: HomeAssistantScanPage(
      onResult: ((p0) => true),
      scanBloc: bloc,
      doubleUrlBloc: urlBloc,
    ),
    initialRoute: "/",
  ));
  await tester.pumpAndSettle();

  Finder finder = find.byType(OutlinedButton);
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle(const Duration(milliseconds: 3000));

  expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
      isFalse);

  await tester.enterText(find.byType(TextFormField).first, url);
  await tester.pump(const Duration(milliseconds: 400));

  expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
      isValid);
}
