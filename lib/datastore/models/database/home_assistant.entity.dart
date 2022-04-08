import 'package:floor/floor.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart'
    as home_assistant;

@Entity(tableName: 'Entity', primaryKeys: [
  'entity_id',
  'plant_id'
], foreignKeys: [
  ForeignKey(
    childColumns: ['plant_id'],
    parentColumns: ['id'],
    entity: Plant,
  )
])
class HomeAssistantEntity {
  @ColumnInfo(name: 'entity_id')
  final String entityId;
  @ColumnInfo(name: 'plant_id')
  final int plantId;
  final home_assistant.Entity entity;

  const HomeAssistantEntity(
    this.plantId,
    this.entityId,
    this.entity,
  );
}
