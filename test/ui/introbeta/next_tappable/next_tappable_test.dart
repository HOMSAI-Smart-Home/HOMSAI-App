import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/ai_service/ai_service.repository.dart';
import 'package:homsai/crossconcern/helpers/models/forms/credentials/email.model.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/main.dart';
import 'package:homsai/themes/app.theme.dart';
import 'package:homsai/ui/pages/intro_beta/bloc/intro_beta.bloc.dart';
import 'package:homsai/ui/pages/intro_beta/intro_beta.page.dart';
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:mockito/annotations.dart';

import 'next_tappable_test.mocks.dart';

class MockIntroBetaBloc extends MockBloc<IntroBetaEvent, IntroBetaState>
    implements IntroBetaBloc {}

@GenerateMocks([AIServiceRepository, HomsaiDatabase])
void main() {
  group("IntroBetaPage", () {
    testWidgets('should enable button if initial email is valid',
        (WidgetTester tester) async {
      final MockAIServiceRepository mockAIServiceRepository =
          MockAIServiceRepository();
      final MockHomsaiDatabase mockHomsaiDatabase = MockHomsaiDatabase();

      getIt.allowReassignment = true;
      getIt.registerLazySingleton<AIServiceInterface>(
          () => mockAIServiceRepository);
      getIt.registerLazySingleton<AppPreferencesInterface>(
          () => AppPreferences());
      getIt.registerLazySingleton<HomsaiDatabase>(() => mockHomsaiDatabase);

      var email = 'demo@demo.it';
      var emailValidator = Email.dirty(email);
      var validate = Formz.validate([emailValidator]);

      expect(validate, FormzStatus.valid);

      final bloc = IntroBetaBloc(
        state: IntroBetaState(
          initialEmail: email,
          email: Email.pure(email),
          status: validate,
        ),
      );

      await tester.pumpWidget(MaterialApp(
        title: "introbeta",
        theme: HomsaiThemeData.lightThemeData,
        localizationsDelegates: const [
          ...HomsaiLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate()
        ],
        supportedLocales: HomsaiLocalizations.supportedLocales,
        home: IntroBetaPage(onResult: ((p0) => true), introBetaBloc: bloc),
        initialRoute: "/",
      ));
      await tester.pumpAndSettle();

      expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
          isTrue);
    });
  });

  testWidgets('should enable button if written email is valid',
      (WidgetTester tester) async {
    final MockAIServiceRepository mockAIServiceRepository =
        MockAIServiceRepository();
    final MockHomsaiDatabase mockHomsaiDatabase = MockHomsaiDatabase();

    getIt.allowReassignment = true;
    getIt.registerLazySingleton<AIServiceInterface>(
        () => mockAIServiceRepository);
    getIt
        .registerLazySingleton<AppPreferencesInterface>(() => AppPreferences());
    getIt.registerLazySingleton<HomsaiDatabase>(() => mockHomsaiDatabase);

    final bloc = IntroBetaBloc();

    await tester.pumpWidget(MaterialApp(
      title: "introbeta",
      theme: HomsaiThemeData.lightThemeData,
      localizationsDelegates: const [
        ...HomsaiLocalizations.localizationsDelegates,
        LocaleNamesLocalizationsDelegate()
      ],
      supportedLocales: HomsaiLocalizations.supportedLocales,
      home: IntroBetaPage(onResult: ((p0) => true), introBetaBloc: bloc),
      initialRoute: "/",
    ));
    await tester.pumpAndSettle();

    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isFalse);

    await tester.enterText(find.byType(TextFormField), "demo@demo.demo");
    await tester.pump(const Duration(milliseconds: 400));

    expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled,
        isTrue);
  });
}
