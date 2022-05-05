import 'package:floor/floor.dart';

abstract class BaseDao<T> {
  @insert
  Future<int> insertItem(T item);

  @insert
  Future<List<int>> insertItems(List<T> items);

  @update
  Future<int> updateItem(T item);

  @update
  Future<void> updateItems(List<T> items);

  @delete
  Future<void> deleteItem(T item);

  @delete
  Future<void> deleteItems(List<T> items);
}
