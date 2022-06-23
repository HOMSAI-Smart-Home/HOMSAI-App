import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:homsai/business/flutter_web_auth/flutter_web_auth.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.interface.dart';
import 'package:homsai/business/home_assistant/home_assistant.repository.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.interface.dart';
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.repository.dart';
import 'package:homsai/crossconcern/components/utils/double_url/bloc/double_url.bloc.dart';
import 'package:homsai/crossconcern/helpers/models/forms/url.model.dart';
import 'package:homsai/crossconcern/utilities/properties/api.proprties.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart';
import 'package:homsai/datastore/local/apppreferences/app_preferences.repository.dart';
import 'package:homsai/datastore/remote/network/network.manager.dart';
import 'package:homsai/datastore/remote/network/network_manager.interface.dart';
import 'package:homsai/datastore/remote/rest/remote.Interface.dart';
import 'package:homsai/main.dart';
import 'package:homsai/ui/pages/scan/bloc/home_assistant_scan.bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as test;

import 'external_auth_test.mocks.dart';

class MockFlutterWebAuth implements FlutterWebAuthInterface {
  @override
  Future<String> authenticate({
    required String url,
    required String callbackUrlScheme,
  }) {
    return Future.value(
      Uri.parse(url).replace(queryParameters: {
        HomeAssistantApiProprties.authResponseType: '12345',
      }).toString(),
    );
  }
}

@GenerateMocks([
  HomeAssistantRepository,
  HomeAssistantScannerRepository,
  RemoteInterface,
  NetworkManager,
])
Future<void> main() async {
  late String ipTestCorrect;
  late String ipTestWrongIp;
  late String ipTestWrongToken;
  late Map<String, dynamic> token;

  late MockRemoteInterface mockRemoteInterface;
  late MockHomeAssistantScannerRepository mockHomeAssistantScannerRepository;
  late MockNetworkManager mockNetworkManager;
  late HomeAssistantRepository homeAssistantRepository;

  test.group(
    'retrieve and check auth token from external home assistant login',
    () {
      Future<void> externalAuthBloc({
        required String urlTest,
        required List<test.TypeMatcher> states,
        required HomeAssistantScanStatus finalState,
      }) async {
        final bloc = HomeAssistantScanBloc(
          DoubleUrlBloc(),
          initialState: HomeAssistantScanState(
            scannedUrls: [urlTest],
            selectedUrl: Url.pure(urlTest),
          ),
        );

        final url = Uri.parse(urlTest).replace(
          path: HomeAssistantApiProprties.authPath,
          queryParameters: {
            'response_type': HomeAssistantApiProprties.authResponseType,
            'client_id': HomeAssistantApiProprties.authClientId,
            'redirect_uri': '${HomeAssistantApiProprties.authCallbackScheme}:/'
          },
        );

        when(mockHomeAssistantScannerRepository.canConnectToHomeAssistant(
          url: Uri.parse(urlTest),
          timeout: argThat(test.anything, named: 'timeout'),
        )).thenAnswer((realInvocation) async {
          if (realInvocation.namedArguments[const Symbol('url')].toString() !=
              ipTestWrongIp) {
            return realInvocation.namedArguments[const Symbol('url')];
          }
          return null;
        });

        when(mockRemoteInterface.post(
          url.replace(
            path: HomeAssistantApiProprties.tokenPath,
            queryParameters: {},
          ),
          body: argThat(test.anything, named: 'body'),
          encoding: argThat(test.anything, named: 'encoding'),
          fallbackUrl: argThat(test.anything, named: 'fallbackUrl'),
          headers: argThat(test.anything, named: 'headers'),
          timeout: argThat(test.anything, named: 'timeout'),
        )).thenAnswer((realInvocation) async {
          if ((realInvocation.positionalArguments[0] as Uri)
                  .replace(path: '')
                  .toString()
                  .replaceAll('?', '') !=
              ipTestWrongToken) {
            return token;
          }
          throw Exception();
        });

        when(mockHomeAssistantScannerRepository.scanNetwork(
          timeout: argThat(test.anything, named: 'timeout'),
        )).thenAnswer((realInvocation) => Stream.fromIterable([urlTest]));

        when(mockNetworkManager.getConnectionType())
            .thenAnswer((realInvocation) async => ConnectivityResult.wifi);

        bloc.add(UrlSubmitted(onSubmit: (_, __) {}));

        await test.expectLater(
          bloc.stream,
          test.emitsInOrder(states),
        );

        test.expect(
          bloc.state.status,
          finalState,
        );
      }

      test.setUp(() async {
        ipTestCorrect = 'http://127.0.0.1:8123';
        ipTestWrongIp = 'http://0.0.0.0:0';
        ipTestWrongToken = 'http://0.0.0.0:8123';

        token = {
          'access_token': '1234',
          'expires_in': 1800,
          'refresh_token': '1234',
          'token_type': 'Bearer'
        };

        WidgetsFlutterBinding.ensureInitialized();
        getIt.allowReassignment = true;

        mockRemoteInterface = MockRemoteInterface();
        mockHomeAssistantScannerRepository =
            MockHomeAssistantScannerRepository();
        mockNetworkManager = MockNetworkManager();

        getIt.registerLazySingleton<AppPreferencesInterface>(
            () => AppPreferences());
        getIt.registerLazySingleton<RemoteInterface>(() => mockRemoteInterface);
        getIt.registerLazySingleton<NetworkManagerInterface>(
            () => mockNetworkManager);
        getIt.registerLazySingleton<HomeAssistantScannerInterface>(
            () => mockHomeAssistantScannerRepository);

        homeAssistantRepository = HomeAssistantRepository(
          flutterWebAuth: MockFlutterWebAuth(),
        );

        getIt.registerLazySingleton<HomeAssistantInterface>(
            () => homeAssistantRepository);
      });

      test.test(
        'correct auth bloc',
        () async {
          await externalAuthBloc(
            urlTest: ipTestCorrect,
            states: [
              test.isA<HomeAssistantScanState>(),
              test.isA<HomeAssistantScanState>(),
            ],
            finalState: HomeAssistantScanStatus.authenticationSuccess,
          );
        },
      );

      test.test(
        'wrong ip bloc',
        () async {
          await externalAuthBloc(
            urlTest: ipTestWrongIp,
            states: [
              test.isA<HomeAssistantScanState>(),
              test.isA<HomeAssistantScanState>(),
            ],
            finalState: HomeAssistantScanStatus.authenticationFailure,
          );
        },
      );

      test.test(
        'wrong token bloc',
        () async {
          await externalAuthBloc(
            urlTest: ipTestWrongToken,
            states: [
              test.isA<HomeAssistantScanState>(),
              test.isA<HomeAssistantScanState>(),
            ],
            finalState: HomeAssistantScanStatus.authenticationFailure,
          );
        },
      );
    },
  );
}
