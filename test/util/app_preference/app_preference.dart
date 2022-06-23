import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_cached.dto.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util.test.dart';
import 'app_preference.mocks.dart';

@GenerateMocks([AppPreferencesInterface])
class MocksAppPreference {
  static final MockAppPreferencesInterface mockAppPreferencesInterface =
      MockAppPreferencesInterface();

  static void setUp({
    String hassLogBookDtoPath = "assets/test/dailyplancached.json",
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<AppPreferencesInterface>(
        () => mockAppPreferencesInterface);
    //mockGetDailyLogCached(hassLogBookDtoPath);
  }

  static Future<void> mockGetDailyLogCached(String path) async {
    final Map<String, dynamic> dailyPlan = await readJson(path);
    final dpc = DailyPlanCachedDto.fromJson(dailyPlan);
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    dpc.dateFetched = today;

    when(mockAppPreferencesInterface.getDailyPlan()).thenAnswer((_) {
      return dpc;
    });
  }

  static Future<void> mockGetDailyLogExpiredCached(String path) async {
    final Map<String, dynamic> dailyPlan = await readJson(path);
    final dpcy = DailyPlanCachedDto.fromJson(dailyPlan);
    var yesterday = DateTime.now().subtract(Duration(days: 1));
    yesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
    dpcy.dateFetched = yesterday;

    when(mockAppPreferencesInterface.getDailyPlan()).thenAnswer((_) {
      return dpcy;
    });
  }

  static void mockGetDailyLogEmpty() {
    when(mockAppPreferencesInterface.getDailyPlan()).thenAnswer((_) {
      return null;
    });
  }
}
