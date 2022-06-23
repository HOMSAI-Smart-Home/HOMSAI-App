import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './app_preferences.mocks.dart';

@GenerateMocks([AppPreferences])
class MocksAppPreferences {
  static final MockAppPreferences mockAppPreferences = MockAppPreferences();

  static void setUp({
    String hassConfigJsonPath = "assets/test/configuration.json",
    String hassEntitiesJsonPath = "assets/test/entities.json",
  }) {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<AppPreferencesInterface>(
        () => mockAppPreferences);
  }

  static void mockSkipIntroduction(bool skip) {
    when(mockAppPreferences.canSkipIntroduction()).thenAnswer((invocation) {
      return skip;
    });
  }

  static void mockAiServiceToken(AiServiceAuth? auth) {
    when(mockAppPreferences.getAiServiceToken()).thenAnswer((invocation) {
      return auth ??
          AiServiceAuth(token: "token", refreshToken: "refreshToken");
    });
  }
}
