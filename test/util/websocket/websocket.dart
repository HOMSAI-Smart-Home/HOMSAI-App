import 'package:flutter_test/flutter_test.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart';
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart';
import 'package:homsai/main.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart' as test;

import '../util.test.dart';
import './websocket.mocks.dart';

@GenerateMocks([HomeAssistantWebSocketRepository])
class MocksHomsaiDatabase {
  static final MockHomeAssistantWebSocketRepository _mockWebsocket =
      MockHomeAssistantWebSocketRepository();

  static void setUp({
    String hassConfigJsonPath = "assets/test/configuration.json",
    String hassEntitiesJsonPath = "assets/test/entities.json",
    String hassAreasJsonPath = "assets/test/areas.json",
    String hassDevicesJsonPath = "assets/test/devices.json",
    String hassRelatedJsonPath = "assets/test/related.json",
  }) {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<HomeAssistantWebSocketInterface>(
        () => _mockWebsocket);

    mockFetchConfig(hassConfigJsonPath);
    mockFetchStates(hassEntitiesJsonPath);
    mockAreaList(hassAreasJsonPath);
    mockDeviceList(hassDevicesJsonPath);
    mockDeviceRelated(hassRelatedJsonPath);
  }

  static _answerFetch(dynamic response) {
    return (invocation) async {
      if (invocation.positionalArguments[0] != null) {
        (invocation.positionalArguments[0] as WebSocketSubscriberInterface)
            .onDone(response);
      }
    };
  }

  static mockFetchConfig(String path) async {
    when(_mockWebsocket.fetchingConfig(any))
        .thenAnswer(_answerFetch(await readJson(path)));
  }

  static mockFetchStates(String path) async {
    when(_mockWebsocket.fetchingStates(any))
        .thenAnswer(_answerFetch(await readJson(path)));
  }

  static mockAreaList(String path) async {
    when(_mockWebsocket.getAreaList(any))
        .thenAnswer(_answerFetch(await readJson(path)));
  }

  static mockDeviceList(String path) async {
    when(_mockWebsocket.getDeviceList(any))
        .thenAnswer(_answerFetch(await readJson(path)));
  }

  static mockDeviceRelated(String path) async {
    when(_mockWebsocket.getDeviceRelated(any, any))
        .thenAnswer(_answerFetch(await readJson(path)));
  }

  static mockErrors() {
    when(_mockWebsocket.setErrorFunction(
      onGenericException: argThat(test.anything, named: 'onGenericException'),
      onTokenException: argThat(test.anything, named: 'onTokenException'),
      onUrlException: argThat(test.anything, named: 'onUrlException'),
    )).thenAnswer((invocation) => {});
  }
}
