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
class MocksHassWebsocket {
  static final MockHomeAssistantWebSocketRepository _mockWebsocket =
      MockHomeAssistantWebSocketRepository();

  static Future<void> setUp({
    String hassConfigJsonPath = "assets/test/configuration.json",
    String hassEntitiesJsonPath = "assets/test/entities.json",
    String hassAreasJsonPath = "assets/test/areas.json",
    String hassDevicesJsonPath = "assets/test/devices.json",
    String hassRelatedJsonPath = "assets/test/device_related.json",
  }) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    getIt.allowReassignment = true;
    getIt.registerLazySingleton<HomeAssistantWebSocketInterface>(
        () => _mockWebsocket);

    mockConnection();
    mockIsConnected();
    await mockFetchConfig(hassConfigJsonPath);
    await mockFetchStates(hassEntitiesJsonPath);
    await mockAreaList(hassAreasJsonPath);
    await mockDeviceList(hassDevicesJsonPath);
    await mockDeviceRelated(hassRelatedJsonPath);
    mockErrors();
  }

  static mockIsConnected() {
    when(_mockWebsocket.isConnected).thenAnswer((_) => true);
  }

  static mockConnection() {
    when(_mockWebsocket.connect(
            onConnected: argThat(test.isNotNull, named: 'onConnected')))
        .thenAnswer((invocation) async {
      if (invocation.namedArguments['onConnected'] != null) {
        await invocation.namedArguments['onConnected']();
      }
    });
  }

  static mockStateConnection() {
    when(_mockWebsocket.isConnected).thenReturn(true);
  }

  static _answerFetch(dynamic response) {
    return (invocation) async {
      if (invocation.positionalArguments[0] != null) {
        (invocation.positionalArguments[0] as WebSocketSubscriberInterface)
            .onDone(response);
      }
    };
  }

  static Future<void> mockFetchConfig(String path) async {
    final answer = _answerFetch(await readJson(path));
    when(_mockWebsocket.fetchingConfig(any)).thenAnswer(answer);
  }

  static mockFetchStates(String path) async {
    final answer = _answerFetch(await readJson(path));
    when(_mockWebsocket.fetchingStates(any)).thenAnswer(answer);
  }

  static mockAreaList(String path) async {
    final answer = _answerFetch(await readJson(path));
    when(_mockWebsocket.getAreaList(any)).thenAnswer(answer);
  }

  static mockDeviceList(String path) async {
    final answer = _answerFetch(await readJson(path));
    when(_mockWebsocket.getDeviceList(any)).thenAnswer(answer);
  }

  static mockDeviceRelated(String path) async {
    final answer = await readJson(path);
    var id = 0;
    when(_mockWebsocket.getDeviceRelated(any, any)).thenAnswer((invocation) {
      if (invocation.positionalArguments[0] != null) {
        (invocation.positionalArguments[0] as WebSocketSubscriberInterface)
            .onDone(answer[id++]);
      }
    });
  }

  static mockErrors() {
    when(_mockWebsocket.setErrorFunction(
      onGenericException: argThat(test.anything, named: 'onGenericException'),
      onTokenException: argThat(test.anything, named: 'onTokenException'),
      onUrlException: argThat(test.anything, named: 'onUrlException'),
    )).thenAnswer((invocation) => {});
  }
}
