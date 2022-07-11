// Mocks generated by Mockito 5.2.0 from annotations
// in homsai/test/util/database/database.dart.
// Do not manually edit this file.

import 'dart:async' as _i6;

import 'package:homsai/datastore/dao/configuration.dao.dart' as _i4;
import 'package:homsai/datastore/dao/home_assistant.dao.dart' as _i5;
import 'package:homsai/datastore/dao/plant.dao.dart' as _i3;
import 'package:homsai/datastore/dao/user.dao.dart' as _i2;
import 'package:homsai/datastore/local/app.database.dart' as _i8;
import 'package:homsai/datastore/models/database/configuration.entity.dart'
    as _i9;
import 'package:homsai/datastore/models/database/home_assistant.entity.dart'
    as _i13;
import 'package:homsai/datastore/models/database/plant.entity.dart' as _i12;
import 'package:homsai/datastore/models/database/user.entity.dart' as _i11;
import 'package:homsai/datastore/models/entity/base/base.entity.dart' as _i10;
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
  _i6.Future<T?> getEntity<T extends _i10.Entity?>(String? entityId) =>
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

/// A class which mocks [HomeAssistantDao].
///
/// See the documentation for Mockito's code generation for more information.
class MockHomeAssistantDao extends _i1.Mock implements _i5.HomeAssistantDao {
  MockHomeAssistantDao() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i13.HomeAssistantEntity?> findEntityById(
          int? plantId, String? entityId) =>
      (super.noSuchMethod(
              Invocation.method(#findEntityById, [plantId, entityId]),
              returnValue: Future<_i13.HomeAssistantEntity?>.value())
          as _i6.Future<_i13.HomeAssistantEntity?>);
  @override
  _i6.Future<T?> findEntity<T extends _i10.Entity>(
          int? plantId, String? entityId) =>
      (super.noSuchMethod(Invocation.method(#findEntity, [plantId, entityId]),
          returnValue: Future<T?>.value()) as _i6.Future<T?>);
  @override
  _i6.Future<List<_i13.HomeAssistantEntity>> getEntitiesFromCategory(
          int? id, String? category) =>
      (super.noSuchMethod(
              Invocation.method(#getEntitiesFromCategory, [id, category]),
              returnValue: Future<List<_i13.HomeAssistantEntity>>.value(
                  <_i13.HomeAssistantEntity>[]))
          as _i6.Future<List<_i13.HomeAssistantEntity>>);
  @override
  _i6.Future<List<_i13.HomeAssistantEntity>> getAllEntities(int? id) =>
      (super.noSuchMethod(Invocation.method(#getAllEntities, [id]),
              returnValue: Future<List<_i13.HomeAssistantEntity>>.value(
                  <_i13.HomeAssistantEntity>[]))
          as _i6.Future<List<_i13.HomeAssistantEntity>>);
  @override
  _i6.Future<List<int>> insertEntitiesReplace(
          List<_i13.HomeAssistantEntity>? items) =>
      (super.noSuchMethod(Invocation.method(#insertEntitiesReplace, [items]),
              returnValue: Future<List<int>>.value(<int>[]))
          as _i6.Future<List<int>>);
  @override
  _i6.Future<List<int>> insertEntities(
          int? plantId, List<_i10.Entity>? entities) =>
      (super.noSuchMethod(
              Invocation.method(#insertEntities, [plantId, entities]),
              returnValue: Future<List<int>>.value(<int>[]))
          as _i6.Future<List<int>>);
  @override
  _i6.Future<void> refreshPlantEntities(
          int? plantId, List<_i10.Entity>? entities) =>
      (super.noSuchMethod(
          Invocation.method(#refreshPlantEntities, [plantId, entities]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<int> insertItem(_i13.HomeAssistantEntity? item) =>
      (super.noSuchMethod(Invocation.method(#insertItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<List<int>> insertItems(List<_i13.HomeAssistantEntity>? items) =>
      (super.noSuchMethod(Invocation.method(#insertItems, [items]),
              returnValue: Future<List<int>>.value(<int>[]))
          as _i6.Future<List<int>>);
  @override
  _i6.Future<int> updateItem(_i13.HomeAssistantEntity? item) =>
      (super.noSuchMethod(Invocation.method(#updateItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<void> updateItems(List<_i13.HomeAssistantEntity>? items) =>
      (super.noSuchMethod(Invocation.method(#updateItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> forceDeleteItem(_i13.HomeAssistantEntity? item) =>
      (super.noSuchMethod(Invocation.method(#forceDeleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItem(_i13.HomeAssistantEntity? item) =>
      (super.noSuchMethod(Invocation.method(#deleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItems(List<_i13.HomeAssistantEntity>? items) =>
      (super.noSuchMethod(Invocation.method(#deleteItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
}

/// A class which mocks [UserDao].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserDao extends _i1.Mock implements _i2.UserDao {
  MockUserDao() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i11.User?> findUserById(String? id) =>
      (super.noSuchMethod(Invocation.method(#findUserById, [id]),
          returnValue: Future<_i11.User?>.value()) as _i6.Future<_i11.User?>);
  @override
  _i6.Future<List<_i11.User>> findAll() =>
      (super.noSuchMethod(Invocation.method(#findAll, []),
              returnValue: Future<List<_i11.User>>.value(<_i11.User>[]))
          as _i6.Future<List<_i11.User>>);
  @override
  _i6.Future<_i11.User?> findUserByEmail(String? email) =>
      (super.noSuchMethod(Invocation.method(#findUserByEmail, [email]),
          returnValue: Future<_i11.User?>.value()) as _i6.Future<_i11.User?>);
  @override
  _i6.Future<int> insertItem(_i11.User? item) =>
      (super.noSuchMethod(Invocation.method(#insertItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<List<int>> insertItems(List<_i11.User>? items) =>
      (super.noSuchMethod(Invocation.method(#insertItems, [items]),
              returnValue: Future<List<int>>.value(<int>[]))
          as _i6.Future<List<int>>);
  @override
  _i6.Future<int> updateItem(_i11.User? item) =>
      (super.noSuchMethod(Invocation.method(#updateItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<void> updateItems(List<_i11.User>? items) =>
      (super.noSuchMethod(Invocation.method(#updateItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> forceDeleteItem(_i11.User? item) =>
      (super.noSuchMethod(Invocation.method(#forceDeleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItem(_i11.User? item) =>
      (super.noSuchMethod(Invocation.method(#deleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItems(List<_i11.User>? items) =>
      (super.noSuchMethod(Invocation.method(#deleteItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
}

/// A class which mocks [ConfigurationDao].
///
/// See the documentation for Mockito's code generation for more information.
class MockConfigurationDao extends _i1.Mock implements _i4.ConfigurationDao {
  MockConfigurationDao() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<_i9.Configuration?> findConfigurationById(int? id) =>
      (super.noSuchMethod(Invocation.method(#findConfigurationById, [id]),
              returnValue: Future<_i9.Configuration?>.value())
          as _i6.Future<_i9.Configuration?>);
  @override
  _i6.Future<int> insertItem(_i9.Configuration? item) =>
      (super.noSuchMethod(Invocation.method(#insertItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<List<int>> insertItems(List<_i9.Configuration>? items) =>
      (super.noSuchMethod(Invocation.method(#insertItems, [items]),
              returnValue: Future<List<int>>.value(<int>[]))
          as _i6.Future<List<int>>);
  @override
  _i6.Future<int> updateItem(_i9.Configuration? item) =>
      (super.noSuchMethod(Invocation.method(#updateItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<void> updateItems(List<_i9.Configuration>? items) =>
      (super.noSuchMethod(Invocation.method(#updateItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> forceDeleteItem(_i9.Configuration? item) =>
      (super.noSuchMethod(Invocation.method(#forceDeleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItem(_i9.Configuration? item) =>
      (super.noSuchMethod(Invocation.method(#deleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItems(List<_i9.Configuration>? items) =>
      (super.noSuchMethod(Invocation.method(#deleteItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
}

/// A class which mocks [PlantDao].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlantDao extends _i1.Mock implements _i3.PlantDao {
  MockPlantDao() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Future<List<_i12.Plant>> findAllPlants() =>
      (super.noSuchMethod(Invocation.method(#findAllPlants, []),
              returnValue: Future<List<_i12.Plant>>.value(<_i12.Plant>[]))
          as _i6.Future<List<_i12.Plant>>);
  @override
  _i6.Future<_i12.Plant?> findPlantById(int? id) =>
      (super.noSuchMethod(Invocation.method(#findPlantById, [id]),
          returnValue: Future<_i12.Plant?>.value()) as _i6.Future<_i12.Plant?>);
  @override
  _i6.Future<int> insertPlantReplace(_i12.Plant? items) =>
      (super.noSuchMethod(Invocation.method(#insertPlantReplace, [items]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<int> insertItem(_i12.Plant? item) =>
      (super.noSuchMethod(Invocation.method(#insertItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<List<int>> insertItems(List<_i12.Plant>? items) =>
      (super.noSuchMethod(Invocation.method(#insertItems, [items]),
              returnValue: Future<List<int>>.value(<int>[]))
          as _i6.Future<List<int>>);
  @override
  _i6.Future<int> updateItem(_i12.Plant? item) =>
      (super.noSuchMethod(Invocation.method(#updateItem, [item]),
          returnValue: Future<int>.value(0)) as _i6.Future<int>);
  @override
  _i6.Future<void> updateItems(List<_i12.Plant>? items) =>
      (super.noSuchMethod(Invocation.method(#updateItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> forceDeleteItem(_i12.Plant? item) =>
      (super.noSuchMethod(Invocation.method(#forceDeleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItem(_i12.Plant? item) =>
      (super.noSuchMethod(Invocation.method(#deleteItem, [item]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
  @override
  _i6.Future<void> deleteItems(List<_i12.Plant>? items) =>
      (super.noSuchMethod(Invocation.method(#deleteItems, [items]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i6.Future<void>);
}