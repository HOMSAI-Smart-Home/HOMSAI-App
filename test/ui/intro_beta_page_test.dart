import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/ai_service/ai_service.repository.dart';
import 'package:homsai/crossconcern/utilities/properties/database.properties.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/main.dart';
import 'package:homsai/themes/app.theme.dart';
import 'package:homsai/ui/pages/intro_beta/bloc/intro_beta.bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:homsai/ui/pages/intro_beta/intro_beta.page.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as test;
import 'package:flutter_gen/gen_l10n/homsai_localizations.dart';

import 'intro_beta_test.mocks.dart';

class MockIntroBetaBloc extends MockBloc<IntroBetaEvent, IntroBetaState>
    implements IntroBetaBloc {}

@GenerateMocks([AIServiceRepository])
void main() {
  test.group(
      'Intro Beta Page, '
      'got to not registered state if email is not registered in the database',
      () {
    blocTest<IntroBetaBloc, IntroBetaState>(
      'got two state if email is not registered in the database',
      setUp: () async {
        final MockAIServiceRepository mockAIServiceRepository =
            MockAIServiceRepository();

        // It enables to reassign an implementation of an interface, for example in Unit tests
        getIt.allowReassignment = true;

        getIt.registerLazySingleton<AIServiceInterface>(
            () => mockAIServiceRepository);
        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
        final database = await $FloorHomsaiDatabase
            .databaseBuilder(DatabaseProperties.name)
            .build();
        getIt.registerLazySingleton<HomsaiDatabase>(() => database);

        when(mockAIServiceRepository.getToken(any))
            .thenAnswer((realInvocation) async => throw Exception());
      },
      build: () => IntroBetaBloc(),
      act: (bloc) => bloc.add(OnSubmit(() => {})),
      expect: () => [
        test.isA<IntroBetaState>(),
        test.isA<IntroBetaState>(),
      ],
    );

    test.test(
      'got to not registered state if email is not registered in the database',
      () async {
        final MockAIServiceRepository mockAIServiceRepository =
            MockAIServiceRepository();

        // It enables to reassign an implementation of an interface, for example in Unit tests
        getIt.allowReassignment = true;
        getIt.registerLazySingleton<AIServiceInterface>(
            () => mockAIServiceRepository);
        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
        final database = await $FloorHomsaiDatabase
            .databaseBuilder(DatabaseProperties.name)
            .build();
        getIt.registerLazySingleton<HomsaiDatabase>(() => database);

        when(mockAIServiceRepository.getToken(any))
            .thenAnswer((realInvocation) async => throw Exception());

        final bloc = IntroBetaBloc();
        bloc.add(OnSubmit(() => {}));
        await test.expectLater(
            bloc.stream,
            test.emitsInOrder([
              test.isA<IntroBetaState>(),
              test.isA<IntroBetaState>(),
            ]));
        test.expect(bloc.state.introBetaStatus, IntroBetaStatus.notRegistered);
      },
    );

    flutter_test.testWidgets(
      'got to not registered state if email is not registered in the database',
      (flutter_test.WidgetTester tester) async {
        final MockAIServiceRepository mockAIServiceRepository =
            MockAIServiceRepository();

        // It enables to reassign an implementation of an interface, for example in Unit tests
        getIt.allowReassignment = true;
        getIt.registerLazySingleton<AIServiceInterface>(
            () => mockAIServiceRepository);
        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());

        when(mockAIServiceRepository.getToken(any))
            .thenAnswer((realInvocation) async => throw Exception());

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

        bloc.add(OnSubmit(() => {}));
        await tester.pump(const Duration(seconds: 2));

        flutter_test.expect(
          flutter_test.find.textContaining(
            'Do you want to join the waiting list to try Homsai exclusively?.',
            findRichText: true,
          ),
          flutter_test.findsWidgets,
        );
      },
    );
  });
}
