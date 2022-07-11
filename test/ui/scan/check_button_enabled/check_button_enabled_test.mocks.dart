// Mocks generated by Mockito 5.2.0 from annotations
// in homsai/test/ui/scan/check_button_enabled/check_button_enabled_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;
import 'dart:convert' as _i8;

import 'package:connectivity_plus/connectivity_plus.dart' as _i5;
import 'package:homsai/business/home_assistant_scanner/home_assistant_scanner.repository.dart'
    as _i3;
import 'package:homsai/datastore/remote/network/network.manager.dart' as _i2;
import 'package:homsai/datastore/remote/rest/remote.Interface.dart' as _i6;
import 'package:http/http.dart' as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeNetworkManagerSubscribersHandler_0 extends _i1.Fake
    implements _i2.NetworkManagerSubscribersHandler {}

/// A class which mocks [HomeAssistantScannerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeAssistantScannerRepository extends _i1.Mock
    implements _i3.HomeAssistantScannerRepository {
  MockHomeAssistantScannerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<String> scanNetwork({Duration? timeout}) => (super.noSuchMethod(
      Invocation.method(#scanNetwork, [], {#timeout: timeout}),
      returnValue: Stream<String>.empty()) as _i4.Stream<String>);
  @override
  _i4.Future<Uri?> canConnectToHomeAssistant(
          {Uri? url, Duration? timeout = const Duration(seconds: 2)}) =>
      (super.noSuchMethod(
          Invocation.method(
              #canConnectToHomeAssistant, [], {#url: url, #timeout: timeout}),
          returnValue: Future<Uri?>.value()) as _i4.Future<Uri?>);
}

/// A class which mocks [NetworkManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkManager extends _i1.Mock implements _i2.NetworkManager {
  MockNetworkManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.NetworkManagerSubscribersHandler get subscribersHandler =>
      (super.noSuchMethod(Invocation.getter(#subscribersHandler),
              returnValue: _FakeNetworkManagerSubscribersHandler_0())
          as _i2.NetworkManagerSubscribersHandler);
  @override
  set subscribersHandler(
          _i2.NetworkManagerSubscribersHandler? _subscribersHandler) =>
      super.noSuchMethod(
          Invocation.setter(#subscribersHandler, _subscribersHandler),
          returnValueForMissingStub: null);
  @override
  void subscribe(_i2.NetworkManagerSubscriber? subscriber) =>
      super.noSuchMethod(Invocation.method(#subscribe, [subscriber]),
          returnValueForMissingStub: null);
  @override
  void unsubscribe(_i2.NetworkManagerSubscriber? subscriber) =>
      super.noSuchMethod(Invocation.method(#unsubscribe, [subscriber]),
          returnValueForMissingStub: null);
  @override
  _i4.Future<bool> isConnect() =>
      (super.noSuchMethod(Invocation.method(#isConnect, []),
          returnValue: Future<bool>.value(false)) as _i4.Future<bool>);
  @override
  _i4.Future<_i5.ConnectivityResult> getConnectionType() =>
      (super.noSuchMethod(Invocation.method(#getConnectionType, []),
              returnValue: Future<_i5.ConnectivityResult>.value(
                  _i5.ConnectivityResult.bluetooth))
          as _i4.Future<_i5.ConnectivityResult>);
}

/// A class which mocks [RemoteInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemoteInterface extends _i1.Mock implements _i6.RemoteInterface {
  MockRemoteInterface() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, dynamic> parseResponse(_i7.Response? response) =>
      (super.noSuchMethod(Invocation.method(#parseResponse, [response]),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  _i4.Future<Map<String, dynamic>> get(Uri? url,
          {Map<String, String>? headers,
          Duration? timeout,
          Uri? fallbackUrl}) =>
      (super.noSuchMethod(
              Invocation.method(#get, [
                url
              ], {
                #headers: headers,
                #timeout: timeout,
                #fallbackUrl: fallbackUrl
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i4.Future<Map<String, dynamic>>);
  @override
  _i4.Future<Map<String, dynamic>> post(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i8.Encoding? encoding,
          Duration? timeout,
          Uri? fallbackUrl}) =>
      (super.noSuchMethod(
              Invocation.method(#post, [
                url
              ], {
                #headers: headers,
                #body: body,
                #encoding: encoding,
                #timeout: timeout,
                #fallbackUrl: fallbackUrl
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i4.Future<Map<String, dynamic>>);
  @override
  _i4.Future<Map<String, dynamic>> put(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i8.Encoding? encoding,
          Duration? timeout,
          Uri? fallbackUrl}) =>
      (super.noSuchMethod(
              Invocation.method(#put, [
                url
              ], {
                #headers: headers,
                #body: body,
                #encoding: encoding,
                #timeout: timeout,
                #fallbackUrl: fallbackUrl
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i4.Future<Map<String, dynamic>>);
  @override
  _i4.Future<Map<String, dynamic>> delete(Uri? url,
          {Map<String, String>? headers,
          Object? body,
          _i8.Encoding? encoding,
          Duration? timeout,
          Uri? fallbackUrl}) =>
      (super.noSuchMethod(
              Invocation.method(#delete, [
                url
              ], {
                #headers: headers,
                #body: body,
                #encoding: encoding,
                #timeout: timeout,
                #fallbackUrl: fallbackUrl
              }),
              returnValue:
                  Future<Map<String, dynamic>>.value(<String, dynamic>{}))
          as _i4.Future<Map<String, dynamic>>);
}