import 'package:homsai/business/ai_service/ai_service.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.repository.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan.dto.dart';
import 'package:homsai/datastore/DTOs/remote/ai_service/daily_plan/daily_plan_cached.dto.dart';
import 'package:homsai/datastore/local/app.database.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/light/light.entity.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as test;
import 'package:timezone/timezone.dart';
import '../../util/ai_service/ai_service.dart';
import '../../util/app_preference/app_preference.dart';
import '../../util/database/database.dart';
import '../../util/home_assistant/home_assistant.dart';
import '../../util/util.test.dart';
import 'home_test.mocks.dart';
import 'package:homsai/crossconcern/helpers/extensions/list.extension.dart';

const String dailyPlanCachedPath = "assets/test/dailyplancached.json";
const String entitiesPath = "assets/test/entities_home_page_test.json";
@GenerateMocks([
  HomsaiDatabase,
  AppPreferencesInterface,
  HomeAssistantWebSocketInterface,
  HomeAssistantInterface,
  AIServiceInterface,
  RemoteInterface,
])
Future<void> main() async {
  test.group(
      'Home Page, '
      'Check if daily plan is called once per day and orders correctly the entities',
      () {
    test.setUp(() async {
      MocksHomsaiDatabase.setUp();
      MocksAIService.setUp();
      MocksHomeAssistant.setUp();
    });

    final mockWebSocketRepository = MockHomeAssistantWebSocketInterface();
    final mockRemoteInterface = MockRemoteInterface();
    // final mockAppPreferences = MockAppPreferencesInterface();
    final mockAppPreferences = MocksAppPreference.mockAppPreferencesInterface;

    final mockHomeAssistantInterface =
        MocksHomeAssistant.mockHomeAssistantInterface;
    final mockAIServiceInterface = MocksAIService.mockAIServiceInterface;

    // It enables to reassign an implementation of an interface, for example in Unit tests
    getIt.allowReassignment = true;
    getIt
        .registerLazySingleton<NetworkManagerInterface>(() => NetworkManager());
    getIt.registerLazySingleton<AppPreferencesInterface>(
        () => mockAppPreferences);
    getIt.registerLazySingleton<HomeAssistantWebSocketInterface>(
        () => mockWebSocketRepository);

    getIt.registerLazySingleton<AIServiceInterface>(
        () => mockAIServiceInterface);

    getIt.registerLazySingleton<HomeAssistantInterface>(
        () => mockHomeAssistantInterface);
    getIt.registerLazySingleton<RemoteInterface>(() => mockRemoteInterface);
    getIt.registerLazySingleton<HomeAssistantScannerInterface>(
        () => HomeAssistantScannerRepository());

    getIt.registerLazySingleton<Location>(() => Location('Test', [], [], []));
    getIt.get<AIServiceInterface>();

    test.test(
      'Check if daily plan is called once if daily plan cache is not stored yet',
      () async {

        when(mockWebSocketRepository.connect(
                onConnected: argThat(test.isNotNull, named: 'onConnected')))
            .thenAnswer((invocation) async {
          if (invocation.namedArguments['onConnected'] != null) {
            await invocation.namedArguments['onConnected']();
          }
        });

        when(mockWebSocketRepository.setErrorFunction(
          onGenericException:
              argThat(test.anything, named: 'onGenericException'),
          onTokenException: argThat(test.anything, named: 'onTokenException'),
          onUrlException: argThat(test.anything, named: 'onUrlException'),
        )).thenAnswer((invocation) => {});

        final bloc = HomeBloc(WebSocketBloc());

        /**
         * Get entities from file and set it as the current entities
         */
        final List<dynamic> entitiesJson = await readJson(entitiesPath);
        List<Entity> entities = [];
        entitiesJson
            .getEntities<Entity>()
            .forEach((entity) => entities.add(entity));

        when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
          return null;
        });

        bloc.add(FetchedLights(
          entities: entities,
        ));

        await untilCalled(mockAIServiceInterface.getDailyPlan(
          argThat(test.anything),
          argThat(test.anything),
          argThat(test.anything),
        ));

        final Map<String, dynamic> dailyPlan =
            await readJson(dailyPlanCachedPath);
        final dpc = DailyPlanCachedDto.fromJson(dailyPlan);
        var today = DateTime.now();
        today = DateTime(today.year, today.month, today.day);
        dpc.dateFetched = today;

        when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
          return dpc;
        });

        MocksAppPreference.mockGetDailyLogCached(
            "assets/test/dailyplancached.json");

        bloc.add(FetchedLights(
          entities: entities,
        ));

        await test.expectLater(
          bloc.stream,
          test.emits(test.emitsInOrder([
            test.isA<HomeState>(),
          ])),
        );

        verify(mockAIServiceInterface.getDailyPlan(
          argThat(test.anything),
          argThat(test.anything),
          argThat(test.anything),
        )).called(1);
      },
    );

    test.test(
      'Check if daily plan is called once if daily plan cache is expired',
      () async {
        final mockAIServiceInterface = MocksAIService.mockAIServiceInterface;

        when(mockWebSocketRepository.connect(
                onConnected: argThat(test.isNotNull, named: 'onConnected')))
            .thenAnswer((invocation) async {
          if (invocation.namedArguments['onConnected'] != null) {
            await invocation.namedArguments['onConnected']();
          }
        });

        when(mockWebSocketRepository.setErrorFunction(
          onGenericException:
              argThat(test.anything, named: 'onGenericException'),
          onTokenException: argThat(test.anything, named: 'onTokenException'),
          onUrlException: argThat(test.anything, named: 'onUrlException'),
        )).thenAnswer((invocation) => {});

        final Map<String, dynamic> dailyPlan =
            await readJson(dailyPlanCachedPath);
        final dpcy = DailyPlanCachedDto.fromJson(dailyPlan);
        var yesterday = DateTime.now().subtract(const Duration(days: 1));
        yesterday = DateTime(yesterday.year, yesterday.month, yesterday.day);
        dpcy.dateFetched = yesterday;

        when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
          return dpcy;
        });

        final bloc = HomeBloc(WebSocketBloc());

        /**
         * Get entities from file and set it as the current entities
         */
        final List<dynamic> entitiesJson = await readJson(entitiesPath);
        List<Entity> entities = [];
        entitiesJson
            .getEntities<Entity>()
            .forEach((entity) => entities.add(entity));


        bloc.add(FetchedLights(
          entities: entities,
        ));

        await untilCalled(mockAIServiceInterface.getDailyPlan(
          argThat(test.anything),
          argThat(test.anything),
          argThat(test.anything),
        ));

        final Map<String, dynamic> dailyPlanToday =
            await readJson(dailyPlanCachedPath);
        final dpc = DailyPlanCachedDto.fromJson(dailyPlanToday);
        var today = DateTime.now();
        today = DateTime(today.year, today.month, today.day);
        dpc.dateFetched = today;

        when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
          return dpc;
        });

        bloc.add(FetchedLights(
          entities: entities,
        ));

        await test.expectLater(
          bloc.stream,
          test.emits(test.emitsInOrder([
            test.isA<HomeState>(),
          ])),
        );

        verify(mockAIServiceInterface.getDailyPlan(
          argThat(test.anything),
          argThat(test.anything),
          argThat(test.anything),
        )).called(1);
      },
    );

    test.test(
      'Check if daily plan is never called if daily plan cache is stored',
      () async {
        when(mockWebSocketRepository.connect(
                onConnected: argThat(test.isNotNull, named: 'onConnected')))
            .thenAnswer((invocation) async {
          if (invocation.namedArguments['onConnected'] != null) {
            await invocation.namedArguments['onConnected']();
          }
        });

        when(mockWebSocketRepository.setErrorFunction(
          onGenericException:
              argThat(test.anything, named: 'onGenericException'),
          onTokenException: argThat(test.anything, named: 'onTokenException'),
          onUrlException: argThat(test.anything, named: 'onUrlException'),
        )).thenAnswer((invocation) => {});

        final bloc = HomeBloc(WebSocketBloc());

        /**
         * Get entities from file and set it as the current entities
         */
        final List<dynamic> entitiesJson = await readJson(entitiesPath);
        List<Entity> entities = [];
        entitiesJson
            .getEntities<Entity>()
            .forEach((entity) => entities.add(entity));


        final Map<String, dynamic> dailyPlanToday =
            await readJson(dailyPlanCachedPath);
        final dpc = DailyPlanCachedDto.fromJson(dailyPlanToday);
        var today = DateTime.now();
        today = DateTime(today.year, today.month, today.day);
        dpc.dateFetched = today;

        when(mockAppPreferences.getDailyPlan()).thenAnswer((_) {
          return dpc;
        });

        bloc.add(FetchedLights(
          entities: entities,
        ));

        await test.expectLater(
          bloc.stream,
          test.emits(test.emitsInOrder([
            test.isA<HomeState>(),
          ])),
        );

        bloc.add(FetchedLights(
          entities: entities,
        ));

        verifyNever(mockAIServiceInterface.getDailyPlan(
          argThat(test.anything),
          argThat(test.anything),
          argThat(test.anything),
        ));
      },
    );

    test.test(
      'Check order devices by daily plan',
      () async {
        when(mockWebSocketRepository.setErrorFunction(
          onGenericException:
              argThat(test.anything, named: 'onGenericException'),
          onTokenException: argThat(test.anything, named: 'onTokenException'),
          onUrlException: argThat(test.anything, named: 'onUrlException'),
        )).thenAnswer((invocation) => {});

        final bloc = HomeBloc(WebSocketBloc());

        final List<dynamic> entitiesJson = await readJson(entitiesPath);
        List<LightEntity> entities = [];
        entitiesJson
            .getEntities<LightEntity>()
            .forEach((entity) => entities.add(entity));

        final dailyPlanDto =
            await mockAIServiceInterface.getDailyPlan(null, null, null);

        final lights = bloc.orderDevicesByDailyPlan(dailyPlanDto, entities);
        final lightIds = lights.map((e) => e.entityId);

        final currentHour = TZDateTime.now(getIt.get<Location>()).hour;

        List<DeviceDto> currentDevicePlan =
            dailyPlanDto.dailyPlan[currentHour].deviceId;

        final currentDevicePlanIds = currentDevicePlan.map((e) => e.entityId);

        test.expect(lightIds, currentDevicePlanIds);
      },
    );
  });
}
