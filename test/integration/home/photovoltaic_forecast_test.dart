import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/dashboard/tabs/home/bloc/home.bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:timezone/timezone.dart';

import '../../util/ai_service/ai_service.dart';
import '../../util/apppreferences/app_preferences.dart';
import '../../util/database/database.dart';
import '../../util/home_assistant/home_assistant.dart';
import '../../util/websocket/websocket.dart';
import 'photovoltaic_forecast_test.mocks.dart';

@GenerateMocks([NetworkManager])
Future<void> main() async {
  group(
      'Home Page, '
      'Check if daily plan is called once per day and orders correctly the entities',
      () {
    setUp(() async {
      getIt.registerLazySingleton<Location>(() => Location('Test', [], [], []));
      await MocksHomsaiDatabase.setUp(
        photovoltaicInstallationDate: DateTime.now(),
        photovoltaicNominalPower: 8.75,
      );
      MocksAIService.setUp();
      await MocksHomeAssistant.setUp();
      await MocksAppPreferences.setUp();
      await MocksHassWebsocket.setUp();

      getIt.registerLazySingleton<NetworkManagerInterface>(
          () => MockNetworkManager());
    });

    test("Retrieve correct photovoltaic data", () async {
      final bloc = HomeBloc(WebSocketBloc());
      bloc.add(FetchPhotovoltaicForecast());
      await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<HomeState>(),
          ]));
      expect(bloc.state.forecastData.isNotEmpty, isTrue);
    });
  });
}
