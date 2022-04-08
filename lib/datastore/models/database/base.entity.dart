import 'package:floor/floor.dart';

class BaseEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;

  BaseEntity(this.id);
}
