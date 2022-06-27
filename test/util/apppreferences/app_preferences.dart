import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_cached.dto.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/models/ai_service_auth.model.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util.test.dart';
import 'app_preferences.mocks.dart';

@GenerateMocks([AppPreferences])
class MocksAppPreferences {
  static final MockAppPreferences mockAppPreferences = MockAppPreferences();

  static Future<void> setUp({
    String hassConfigJsonPath = "assets/test/configuration.json",
    String hassEntitiesJsonPath = "assets/test/entities.json",
    String hassLogBookDtoPath = "assets/test/dailyplancached.json",
    String optimizedChart = "assets/test/optimized_chart.json",
  }) async {
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

  static Future<void> mockGetDailyLogCached(String path) async {
    final Map<String, dynamic> dailyPlan = await readJson(path);
    final dpc = DailyPlanCachedDto.fromJson(dailyPlan);
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    dpc.dateFetched = today;

    when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
      return dpc;
    });
  }

  static Future<void> mockGetDailyLogExpiredCached(String path) async {
    final Map<String, dynamic> dailyPlan = await readJson(path);
    final dpcy = DailyPlanCachedDto.fromJson(dailyPlan);
    var yesterday = DateTime.now().subtract(const Duration(days: 1));
    yesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
    dpcy.dateFetched = yesterday;

    when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
      return dpcy;
    });
  }

  static void mockGetDailyLogEmpty() {
    when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
      return null;
    });
  }

  static mockGetConsumptionInfoEmpty() {
    when(mockAppPreferences.getConsumptionInfo()).thenAnswer((_) {
      return null;
    });
  }

  static mockGetProductionInfoEmpty() {
    when(mockAppPreferences.getProductionInfo()).thenAnswer((_) {
      return null;
    });
  }

  static mockGetBatteryInfoEmpty() {
    when(mockAppPreferences.getBatteryInfo()).thenAnswer((_) {
      return null;
    });
  }

  static mockGetOptimizationForecast() {
    when(mockAppPreferences.getOptimizationForecast()).thenAnswer((_) {
      return null;
    });
  }
}
