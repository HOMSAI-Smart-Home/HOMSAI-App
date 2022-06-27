import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart';
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart';
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

  static final Map<String, List<HistoryDto>> _historyMap = {};

  static Future<void> setUp({
    String hassLogBookDtoPath = "assets/test/logbook.json",
    String optimizedChartDtoPath = "assets/test/optimized_chart.json",
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<HomeAssistantInterface>(
        () => mockHomeAssistantInterface);
    mockGetLogbook(hassLogBookDtoPath);
    await mockGetHistoryFrom(optimizedChartDtoPath);
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

  static Future<void> mockGetHistoryFrom(String path) async {
    final json = await readJson(path);
    final history = (json as Map<String, dynamic>);
    final batteryHistory =
        HistoryDto.fromList(history['sensor.solaredge_storage_power']);
    final productionHistory =
        HistoryDto.fromList(history['sensor.solaredge_solar_power']);
    final consumptionHistory =
        HistoryDto.fromList(history['sensor.solaredge_power_consumption']);

    _historyMap.clear();

    _historyMap.putIfAbsent(
        'sensor.solaredge_storage_power', () => batteryHistory);
    _historyMap.putIfAbsent(
        'sensor.solaredge_solar_power', () => productionHistory);
    _historyMap.putIfAbsent(
        'sensor.solaredge_power_consumption', () => consumptionHistory);
  }

  static void mockHistoryFromSensor() {
    when(mockHomeAssistantInterface.getHistory(
      plant: argThat(anything, named: 'plant'),
      timeout: argThat(anything, named: 'timeout'),
      historyBodyDto: argThat(anything, named: 'historyBodyDto'),
    )).thenAnswer((invocation) async {
      final historyBodyDto =
          invocation.namedArguments[const Symbol('historyBodyDto')] as HistoryBodyDto;
      return Future.value(_historyMap.containsKey(historyBodyDto.filterEntityId)
          ? _historyMap[historyBodyDto.filterEntityId]
          : []);
    });
  }

  static void mockHistoryEntities() {
    _historyMap.clear();
  }
}
