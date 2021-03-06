// Mocks generated by Mockito 5.2.0 from annotations
// in homsai/test/util/websocket/websocket.dart.
// Do not manually edit this file.

import 'dart:async' as _i9;

import 'package:homsai/business/home_assistant/home_assistant.interface.dart'
    as _i3;
import 'package:homsai/crossconcern/helpers/blocs/websocket/websocket.bloc.dart'
    as _i8;
import 'package:homsai/datastore/DTOs/websocket/configuration/configuration_body.dto.dart'
    as _i13;
import 'package:homsai/datastore/DTOs/websocket/device_related/device_related_body.dto.dart'
    as _i14;
import 'package:homsai/datastore/DTOs/websocket/service/service_body.dto.dart'
    as _i12;
import 'package:homsai/datastore/DTOs/websocket/trigger/trigger_body.dto.dart'
    as _i11;
import 'package:homsai/datastore/local/app.database.dart' as _i4;
import 'package:homsai/datastore/local/apppreferences/app_preferences.interface.dart'
    as _i2;
import 'package:homsai/datastore/models/home_assistant_auth.model.dart' as _i7;
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.interface.dart'
    as _i10;
import 'package:homsai/datastore/remote/websocket/home_assistant_websocket.repository.dart'
    as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:web_socket_channel/web_socket_channel.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeAppPreferencesInterface_0 extends _i1.Fake
    implements _i2.AppPreferencesInterface {}

class _FakeHomeAssistantInterface_1 extends _i1.Fake
    implements _i3.HomeAssistantInterface {}

class _FakeHomsaiDatabase_2 extends _i1.Fake implements _i4.HomsaiDatabase {}

/// A class which mocks [HomeAssistantWebSocketRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeAssistantWebSocketRepository extends _i1.Mock
    implements _i5.HomeAssistantWebSocketRepository {
  MockHomeAssistantWebSocketRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AppPreferencesInterface get appPreferencesInterface =>
      (super.noSuchMethod(Invocation.getter(#appPreferencesInterface),
              returnValue: _FakeAppPreferencesInterface_0())
          as _i2.AppPreferencesInterface);
  @override
  _i3.HomeAssistantInterface get homeAssistantRepository =>
      (super.noSuchMethod(Invocation.getter(#homeAssistantRepository),
              returnValue: _FakeHomeAssistantInterface_1())
          as _i3.HomeAssistantInterface);
  @override
  _i4.HomsaiDatabase get appDatabase =>
      (super.noSuchMethod(Invocation.getter(#appDatabase),
          returnValue: _FakeHomsaiDatabase_2()) as _i4.HomsaiDatabase);
  @override
  set webSocket(_i6.WebSocketChannel? _webSocket) =>
      super.noSuchMethod(Invocation.setter(#webSocket, _webSocket),
          returnValueForMissingStub: null);
  @override
  set homeAssistantAuth(_i7.HomeAssistantAuth? _homeAssistantAuth) => super
      .noSuchMethod(Invocation.setter(#homeAssistantAuth, _homeAssistantAuth),
          returnValueForMissingStub: null);
  @override
  int get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: 0) as int);
  @override
  set id(int? _id) => super.noSuchMethod(Invocation.setter(#id, _id),
      returnValueForMissingStub: null);
  @override
  List<Function> get onConnected =>
      (super.noSuchMethod(Invocation.getter(#onConnected),
          returnValue: <Function>[]) as List<Function>);
  @override
  set onConnected(List<Function>? _onConnected) =>
      super.noSuchMethod(Invocation.setter(#onConnected, _onConnected),
          returnValueForMissingStub: null);
  @override
  bool get isConnected =>
      (super.noSuchMethod(Invocation.getter(#isConnected), returnValue: false)
          as bool);
  @override
  bool get isConnecting =>
      (super.noSuchMethod(Invocation.getter(#isConnecting), returnValue: false)
          as bool);
  @override
  _i8.HomeAssistantWebSocketStatus get status =>
      (super.noSuchMethod(Invocation.getter(#status),
              returnValue: _i8.HomeAssistantWebSocketStatus.disconnected)
          as _i8.HomeAssistantWebSocketStatus);
  @override
  void setErrorFunction(
          {dynamic onTokenException,
          dynamic onUrlException,
          dynamic onGenericException}) =>
      super.noSuchMethod(
          Invocation.method(#setErrorFunction, [], {
            #onTokenException: onTokenException,
            #onUrlException: onUrlException,
            #onGenericException: onGenericException
          }),
          returnValueForMissingStub: null);
  @override
  _i9.Future<void> connect(
          {Uri? baseUrl, Uri? fallback, Function? onConnected}) =>
      (super.noSuchMethod(
          Invocation.method(#connect, [], {
            #baseUrl: baseUrl,
            #fallback: fallback,
            #onConnected: onConnected
          }),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i9.Future<void>);
  @override
  _i9.Future<void> reconnect({Function? onConnected}) => (super.noSuchMethod(
      Invocation.method(#reconnect, [], {#onConnected: onConnected}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i9.Future<void>);
  @override
  _i9.Future<void> logout() =>
      (super.noSuchMethod(Invocation.method(#logout, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i9.Future<void>);
  @override
  void removeSubscription(
          String? event, _i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(
          Invocation.method(#removeSubscription, [event, subscriber]),
          returnValueForMissingStub: null);
  @override
  void subscribeEvent(
          String? event, _i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(
          Invocation.method(#subscribeEvent, [event, subscriber]),
          returnValueForMissingStub: null);
  @override
  void subscribeTrigger(
          String? event,
          _i10.WebSocketSubscriberInterface? subscriber,
          _i11.TriggerBodyDto? trigger) =>
      super.noSuchMethod(
          Invocation.method(#subscribeTrigger, [event, subscriber, trigger]),
          returnValueForMissingStub: null);
  @override
  void unsubscribingFromEvents(
          String? event, _i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(
          Invocation.method(#unsubscribingFromEvents, [event, subscriber]),
          returnValueForMissingStub: null);
  @override
  void fireAnEvent(
          _i10.WebSocketSubscriberInterface? subscriber, String? eventType,
          {Map<String, String>? eventData}) =>
      super.noSuchMethod(
          Invocation.method(
              #fireAnEvent, [subscriber, eventType], {#eventData: eventData}),
          returnValueForMissingStub: null);
  @override
  void callingAService(
          _i10.WebSocketSubscriberInterface? subscriber,
          String? domain,
          String? service,
          _i12.ServiceBodyDto? serviceBodyDto) =>
      super.noSuchMethod(
          Invocation.method(
              #callingAService, [subscriber, domain, service, serviceBodyDto]),
          returnValueForMissingStub: null);
  @override
  void fetchingStates(_i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#fetchingStates, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void fetchingConfig(_i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#fetchingConfig, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void fetchingServices(_i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#fetchingServices, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void fetchingMediaPlayerThumbnails(
          _i10.WebSocketSubscriberInterface? subscriber, String? entityId) =>
      super.noSuchMethod(
          Invocation.method(
              #fetchingMediaPlayerThumbnails, [subscriber, entityId]),
          returnValueForMissingStub: null);
  @override
  void validateConfig(_i10.WebSocketSubscriberInterface? subscriber,
          String? entityId, _i13.ConfigurationBodyDto? configurationBodyDto) =>
      super.noSuchMethod(
          Invocation.method(
              #validateConfig, [subscriber, entityId, configurationBodyDto]),
          returnValueForMissingStub: null);
  @override
  void getDeviceList(_i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#getDeviceList, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void getAreaList(_i10.WebSocketSubscriberInterface? subscriber) =>
      super.noSuchMethod(Invocation.method(#getAreaList, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void getDeviceRelated(_i10.WebSocketSubscriberInterface? subscriber,
          _i14.DeviceRelatedBodyDto? deviceRelatedBodyDto) =>
      super.noSuchMethod(
          Invocation.method(
              #getDeviceRelated, [subscriber, deviceRelatedBodyDto]),
          returnValueForMissingStub: null);
}
