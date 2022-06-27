import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart' as test;
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../../util/ai_service/ai_service.dart';
import '../../../util/apppreferences/app_preferences.dart';
import '../../../util/database/database.dart';
import '../../../util/home_assistant/home_assistant.dart';
import '../../../util/websocket/websocket.dart';

import 'check_history_test.mocks.dart';

@GenerateMocks([NetworkManager])
Future<void> main() async {
  test.group(
    'Optimized Chart, create mockup and check if sensor history is correct',
    () {
      Future<void> fetchHistory() async {
        final bloc = HomeBloc(
          WebSocketBloc(),
        );

        bloc.add(FetchHistory());
        await Future.delayed(const Duration(seconds: 2));

        test.expect(bloc.state.batteryPlot, test.isNotNull);
        test.expect(bloc.state.batteryPlot, test.isNotEmpty);
        test.expect(bloc.state.consumptionPlot, test.isNotNull);
        test.expect(bloc.state.consumptionPlot, test.isNotEmpty);
        test.expect(bloc.state.productionPlot, test.isNotNull);
        test.expect(bloc.state.productionPlot, test.isNotEmpty);
        test.expect(bloc.state.optimizedBatteryPlot, test.isNotNull);
        test.expect(bloc.state.optimizedBatteryPlot, test.isNotEmpty);
        test.expect(bloc.state.optimizedConsumptionPlot, test.isNotNull);
        test.expect(bloc.state.optimizedConsumptionPlot, test.isNotEmpty);
      }

      test.setUp(() async {
        tz.initializeTimeZones();
        await MocksHomsaiDatabase.setUp(
          productionSensor: 'sensor.solaredge_solar_power',
          batterySensor: 'sensor.solaredge_storage_power',
          consumptionSensor: 'sensor.solaredge_power_consumption',
        );
        await MocksHassWebsocket.setUp();
        await MocksHassWebsocket.mockStateConnection();
        await MocksAppPreferences.setUp();
        MocksAppPreferences.mockGetBatteryInfoEmpty();
        MocksAppPreferences.mockGetConsumptionInfoEmpty();
        MocksAppPreferences.mockGetProductionInfoEmpty();
        MocksAppPreferences.mockGetOptimizationForecast();
        MocksAIService.setUp();

        getIt.registerLazySingleton<Location>(
            () => getLocation('America/Detroit'));
        await MocksHomeAssistant.setUp();
        MocksHomeAssistant.mockHistoryFromSensor();

        getIt.registerLazySingleton<NetworkManagerInterface>(
            () => MockNetworkManager());
      });

      test.test(
        'check if sensor history is correct',
        () async {
          await fetchHistory();
        },
      );
    },
  );
}
