// Mocks generated by Mockito 5.2.0 from annotations
// in homsai/test/integration/add_plant_page/add_plant_page_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart'
    as _i14;
import 'package:homsai/datastore/dao/configuration.dao.dart' as _i4;
import 'package:homsai/datastore/dao/home_assistant.dao.dart' as _i5;
import 'package:homsai/datastore/dao/plant.dao.dart' as _i3;
import 'package:homsai/datastore/dao/user.dao.dart' as _i2;
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration_body.dto.dart'
    as _i17;
import 'package:homsai/datastore/DTOs/websocket/device_related/device_related_body.dto.dart'
    as _i18;
import 'package:homsai/datastore/DTOs/websocket/service/service_body.dto.dart'
    as _i16;
import 'package:homsai/datastore/DTOs/websocket/trigger/trigger_body.dto.dart'
    as _i15;
import 'package:homsai/datastore/local/app.database.dart' as _i8;
import 'package:homsai/datastore/models/database/configuration.entity.dart'
    as _i9;
import 'package:homsai/datastore/models/database/plant.entity.dart' as _i12;
import 'package:homsai/datastore/models/database/user.entity.dart' as _i11;
import 'package:homsai/datastore/models/entity/base/base.entity.dart' as _i10;
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart'
    as _i13;
import 'package:mockito/mockito.dart' as _i1;
import 'package:sqflite/sqflite.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeUserDao_0 extends _i1.Fake implements _i2.UserDao {}

class _FakePlantDao_1 extends _i1.Fake implements _i3.PlantDao {}

class _FakeConfigurationDao_2 extends _i1.Fake implements _i4.ConfigurationDao {
}

class _FakeHomeAssistantDao_3 extends _i1.Fake implements _i5.HomeAssistantDao {
}

class _FakeStreamController_4<T> extends _i1.Fake
    implements _i6.StreamController<T> {}

class _FakeDatabaseExecutor_5 extends _i1.Fake implements _i7.DatabaseExecutor {
}

/// A class which mocks [HomsaiDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomsaiDatabase extends _i1.Mock implements _i8.HomsaiDatabase {
  MockHomsaiDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.UserDao get userDao => (super.noSuchMethod(Invocation.getter(#userDao),
      returnValue: _FakeUserDao_0()) as _i2.UserDao);
  @override
  _i3.PlantDao get plantDao => (super.noSuchMethod(Invocation.getter(#plantDao),
      returnValue: _FakePlantDao_1()) as _i3.PlantDao);
  @override
  _i4.ConfigurationDao get configurationDao =>
      (super.noSuchMethod(Invocation.getter(#configurationDao),
          returnValue: _FakeConfigurationDao_2()) as _i4.ConfigurationDao);
  @override
  _i5.HomeAssistantDao get homeAssitantDao =>
      (super.noSuchMethod(Invocation.getter(#homeAssitantDao),
          returnValue: _FakeHomeAssistantDao_3()) as _i5.HomeAssistantDao);
  @override
  _i6.StreamController<String> get changeListener =>
      (super.noSuchMethod(Invocation.getter(#changeListener),
              returnValue: _FakeStreamController_4<String>())
          as _i6.StreamController<String>);
  @override
  set changeListener(_i6.StreamController<String>? _changeListener) =>
      super.noSuchMethod(Invocation.setter(#changeListener, _changeListener),
          returnValueForMissingStub: null);
  @override
  _i7.DatabaseExecutor get database =>
      (super.noSuchMethod(Invocation.getter(#database),
          returnValue: _FakeDatabaseExecutor_5()) as _i7.DatabaseExecutor);
  @override
  set database(_i7.DatabaseExecutor? _database) =>
      super.noSuchMethod(Invocation.setter(#database, _database),
          returnValueForMissingStub: null);
  @override
  _i6.Future<_i9.Configuration?> getConfiguration() =>
      (super.noSuchMethod(Invocation.method(#getConfiguration, []),
              returnValue: Future<_i9.Configuration?>.value())
          as _i6.Future<_i9.Configuration?>);
  @override
  _i6.Future<List<T>> getEntities<T extends _i10.Entity>() =>
      (super.noSuchMethod(Invocation.method(#getEntities, []),
          returnValue: Future<List<T>>.value(<T>[])) as _i6.Future<List<T>>);
  @override
  _i6.Future<void> updatePlant(int? plantId) =>
      (super.noSuchMethod(Invocation.method(#updatePlant, [plantId]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<_i11.User?> getUser() =>
      (super.noSuchMethod(Invocation.method(#getUser, []),
          returnValue: Future<_i11.User?>.value()) as _i6.Future<_i11.User?>);
  @override
  _i6.Future<_i12.Plant?> getPlant() =>
      (super.noSuchMethod(Invocation.method(#getPlant, []),
          returnValue: Future<_i12.Plant?>.value()) as _i6.Future<_i12.Plant?>);
  @override
  _i6.Future<T?> getEntity<T extends _i10.Entity>(String? entityId) =>
      (super.noSuchMethod(Invocation.method(#getEntity, [entityId]),
          returnValue: Future<T?>.value()) as _i6.Future<T?>);
  @override
  _i6.Future<void> logout({bool? deleteUser = true}) => (super.noSuchMethod(
      Invocation.method(#logout, [], {#deleteUser: deleteUser}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
}

/// A class which mocks [HomeAssistantWebSocketInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeAssistantWebSocketInterface extends _i1.Mock
    implements _i13.HomeAssistantWebSocketInterface {
  MockHomeAssistantWebSocketInterface() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected), returnValue: false)
          as bool);
  @override
  bool get isConnecting =>
      (super.noSuchMethod(Invocation.getter(#isConnecting), returnValue: false)
          as bool);
  @override
  _i14.HomeAssistantWebSocketStatus get status =>
      (super.noSuchMethod(Invocation.getter(#status),
              returnValue: _i14.HomeAssistantWebSocketStatus.disconnected)
          as _i14.HomeAssistantWebSocketStatus);
  @override
  _i6.Future<void> connect(
          {Uri? baseUrl, Uri? fallback, Function? onConnected}) =>
      (super.noSuchMethod(
          Invocation.method(#connect, [], {
            #baseUrl: baseUrl,
            #fallback: fallback,
            #onConnected: onConnected
          }),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> reconnect({Function? onConnected}) => (super.noSuchMethod(
      Invocation.method(#reconnect, [], {#onConnected: onConnected}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> logout() =>
      (super.noSuchMethod(Invocation.method(#logout, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  void removeSubscription(
          String? event, _i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(
          Invocation.method(#removeSubscription, [event, subscriber]),
          returnValueForMissingStub: null);
  @override
  void subscribeEvent(
          String? event, _i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(
          Invocation.method(#subscribeEvent, [event, subscriber]),
          returnValueForMissingStub: null);
  @override
  void subscribeTrigger(
          String? event,
          _i13.WebSocketSubscriberInterface? subscriber,
          _i15.TriggerBodyDto? trigger) =>
      super.noSuchMethod(
          Invocation.method(#subscribeTrigger, [event, subscriber, trigger]),
          returnValueForMissingStub: null);
  @override
  void unsubscribingFromEvents(
          String? event, _i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(
          Invocation.method(#unsubscribingFromEvents, [event, subscriber]),
          returnValueForMissingStub: null);
  @override
  void fireAnEvent(
          _i13.WebSocketSubscriberInterface? subscriber, String? eventType,
          {Map<String, String>? eventData}) =>
      super.noSuchMethod(
          Invocation.method(
              #fireAnEvent, [subscriber, eventType], {#eventData: eventData}),
          returnValueForMissingStub: null);
  @override
  void callingAService(
          _i13.WebSocketSubscriberInterface? subscriber,
          String? domain,
          String? service,
          _i16.ServiceBodyDto? serviceBodyDto) =>
      super.noSuchMethod(
          Invocation.method(
              #callingAService, [subscriber, domain, service, serviceBodyDto]),
          returnValueForMissingStub: null);
  @override
  void fetchingStates(_i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#fetchingStates, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void fetchingConfig(_i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#fetchingConfig, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void fetchingServices(_i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#fetchingServices, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void fetchingMediaPlayerThumbnails(
          _i13.WebSocketSubscriberInterface? subscriber, String? entityId) =>
      super.noSuchMethod(
          Invocation.method(
              #fetchingMediaPlayerThumbnails, [subscriber, entityId]),
          returnValueForMissingStub: null);
  @override
  void validateConfig(_i13.WebSocketSubscriberInterface? subscriber,
          String? entityId, _i17.ConfigurationBodyDto? configurationBodyDto) =>
      super.noSuchMethod(
          Invocation.method(
              #validateConfig, [subscriber, entityId, configurationBodyDto]),
          returnValueForMissingStub: null);
  @override
  void getDeviceList(_i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#getDeviceList, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void getAreaList(_i13.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#getAreaList, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void getDeviceRelated(_i13.WebSocketSubscriberInterface? subscriber,
          _i18.DeviceRelatedBodyDto? deviceRelatedBodyDto) =>
      super.noSuchMethod(
          Invocation.method(
              #getDeviceRelated, [subscriber, deviceRelatedBodyDto]),
          returnValueForMissingStub: null);
}
