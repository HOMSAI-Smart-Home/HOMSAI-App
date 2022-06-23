import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/forecast/photovoltaic/photovoltaic.dto.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../util.test.dart';
import 'ai_service.mocks.dart';

@GenerateMocks([AIServiceInterface])
class MocksAIService {
  static final MockAIServiceInterface mockAIServiceInterface =
      MockAIServiceInterface();

  static void setUp({
    String hassDailyPlanDtoJsonPath = "assets/test/dailyplandto.json",
    String hassPhotovoltaicJsonPath = "assets/test/photovoltaic.json",
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<AIServiceInterface>(
        () => mockAIServiceInterface);
    mockDailyPlan(hassDailyPlanDtoJsonPath);
    mockPhotovoltaic(hassPhotovoltaicJsonPath);
  }

  static void mockDailyPlan(String path) {
    when(mockAIServiceInterface.getDailyPlan(
      argThat(anything),
      argThat(anything),
      argThat(anything),
    )).thenAnswer((invocation) async {
      final Map<String, dynamic> dailyPlan = await readJson(path);
      return Future<DailyPlanDto>.value(DailyPlanDto.fromJson(dailyPlan));
    });
  }

  static void mockPhotovoltaic(String path) {
    when(mockAIServiceInterface.getPhotovoltaicForecast(any))
        .thenAnswer((invocation) async {
      final List<dynamic> data = await readJson(path);
      return PhotovoltaicForecastDto.fromList(data);
    });
  }
}
