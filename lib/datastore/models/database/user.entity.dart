import 'package:floor/floor.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';

@Entity(tableName: 'User', indices: [
  Index(unique: true, value: ['email']),
], foreignKeys: [
  ForeignKey(
    childColumns: ["plant_id"],
    parentColumns: ["id"],
    entity: Plant,
    onDelete: ForeignKeyAction.setNull
  ),
])
class User {
  @PrimaryKey()
  final String id;
  final String email;

  @ColumnInfo(name: 'plant_id')
  int? plantId;

  User(
    this.id,
    this.email, {
    this.plantId,
  });

  bool get isPlantAvailable => plantId != null;
  bool get isPlantNotAvailable => plantId == null;

  User copyWith({
    String? email,
    int? plantId,
  }) =>
      User(
        id,
        email ?? this.email,
        plantId: plantId ?? this.plantId,
      );
}
