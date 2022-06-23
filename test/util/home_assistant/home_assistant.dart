import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/datastore/DTOs/remote/logbook/logbook.dto.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../integration/home/home_test.mocks.dart';
import '../util.test.dart';

@GenerateMocks([HomeAssistantInterface])
class MocksHomeAssistant {
  static final MockHomeAssistantInterface mockHomeAssistantInterface =
      MockHomeAssistantInterface();

  static void setUp({
    String hassLogBookDtoPath = "assets/test/logbook.json",
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<HomeAssistantInterface>(
        () => mockHomeAssistantInterface);
    mockGetLogbook(hassLogBookDtoPath);
  }

  static void mockGetLogbook(String path) {
    when(mockHomeAssistantInterface.getLogBook(
      plant: argThat(anything, named: "plant"),
      start: argThat(anything, named: "start"),
      logbookBodyDto: argThat(anything, named: "logbookBodyDto"),
    )).thenAnswer((invocation) async {
      final Map<String, dynamic> dailyPlan = await readJson(path);
      return Future<LogbookDto>.value(LogbookDto.fromJson(dailyPlan));
    });
  }
}
