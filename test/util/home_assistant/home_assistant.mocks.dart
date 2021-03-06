// Mocks generated by Mockito 5.2.0 from annotations
// in homsai/test/util/home_assistant/home_assistant.dart.
// Do not manually edit this file.

import 'dart:async' as _i3;

import 'package:homsai/business/home_assistant/home_assistant.interface.dart'
    as _i5;
import 'package:homsai/datastore/DTOs/remote/history/history.dto.dart' as _i7;
import 'package:homsai/datastore/DTOs/remote/history/history_body.dto.dart'
    as _i8;
import 'package:homsai/datastore/DTOs/remote/logbook/logbook.dto.dart' as _i4;
import 'package:homsai/datastore/DTOs/remote/logbook/logbook_body.dto.dart'
    as _i9;
import 'package:homsai/datastore/models/database/plant.entity.dart' as _i6;
import 'package:homsai/datastore/models/home_assistant_auth.model.dart' as _i2;
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

class _FakeHomeAssistantAuth_0 extends _i1.Fake
    implements _i2.HomeAssistantAuth {}

class _FakeStreamSubscription_1<T> extends _i1.Fake
    implements _i3.StreamSubscription<T> {}

class _FakeUri_2 extends _i1.Fake implements Uri {}

class _FakeLogbookDto_3 extends _i1.Fake implements _i4.LogbookDto {}

/// A class which mocks [HomeAssistantInterface].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeAssistantInterface extends _i1.Mock
    implements _i5.HomeAssistantInterface {
  MockHomeAssistantInterface() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i2.HomeAssistantAuth> authenticate(
          {Uri? baseUrl, Uri? fallback}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #authenticate, [], {#baseUrl: baseUrl, #fallback: fallback}),
              returnValue: Future<_i2.HomeAssistantAuth>.value(
                  _FakeHomeAssistantAuth_0()))
          as _i3.Future<_i2.HomeAssistantAuth>);
  @override
  _i3.Future<_i3.StreamSubscription<String>> scan(
          {void Function(String)? onData,
          Function? onError,
          Duration? timeout}) =>
      (super.noSuchMethod(
              Invocation.method(#scan, [],
                  {#onData: onData, #onError: onError, #timeout: timeout}),
              returnValue: Future<_i3.StreamSubscription<String>>.value(
                  _FakeStreamSubscription_1<String>()))
          as _i3.Future<_i3.StreamSubscription<String>>);
  @override
  _i3.Future<Uri> canConnectToHomeAssistant(
          {Uri? baseUrl,
          Uri? fallback,
          Duration? timeout = const Duration(seconds: 2)}) =>
      (super.noSuchMethod(
          Invocation.method(#canConnectToHomeAssistant, [],
              {#baseUrl: baseUrl, #fallback: fallback, #timeout: timeout}),
          returnValue: Future<Uri>.value(_FakeUri_2())) as _i3.Future<Uri>);
  @override
  _i3.Future<_i2.HomeAssistantAuth> refreshToken(
          {Uri? url, Duration? timeout}) =>
      (super.noSuchMethod(
          Invocation.method(#refreshToken, [], {#url: url, #timeout: timeout}),
          returnValue: Future<_i2.HomeAssistantAuth>.value(
              _FakeHomeAssistantAuth_0())) as _i3
          .Future<_i2.HomeAssistantAuth>);
  @override
  _i3.Future<dynamic> revokeToken({_i6.Plant? plant, Duration? timeout}) =>
      (super.noSuchMethod(
          Invocation.method(
              #revokeToken, [], {#plant: plant, #timeout: timeout}),
          returnValue: Future<dynamic>.value()) as _i3.Future<dynamic>);
  @override
  _i3.Future<List<_i7.HistoryDto>> getHistory(
          {_i6.Plant? plant,
          _i8.HistoryBodyDto? historyBodyDto,
          Duration? timeout}) =>
      (super.noSuchMethod(
              Invocation.method(#getHistory, [], {
                #plant: plant,
                #historyBodyDto: historyBodyDto,
                #timeout: timeout
              }),
              returnValue:
                  Future<List<_i7.HistoryDto>>.value(<_i7.HistoryDto>[]))
          as _i3.Future<List<_i7.HistoryDto>>);
  @override
  _i3.Future<_i4.LogbookDto> getLogBook(
          {_i6.Plant? plant,
          DateTime? start,
          _i9.LogbookBodyDto? logbookBodyDto}) =>
      (super.noSuchMethod(
              Invocation.method(#getLogBook, [], {
                #plant: plant,
                #start: start,
                #logbookBodyDto: logbookBodyDto
              }),
              returnValue: Future<_i4.LogbookDto>.value(_FakeLogbookDto_3()))
          as _i3.Future<_i4.LogbookDto>);
}
