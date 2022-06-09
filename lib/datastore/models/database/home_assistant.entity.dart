import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:homsai/datastore/models/database/plant.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart' as hass;

@Entity(tableName: 'Entity', primaryKeys: [
  'entity_id',
  'plant_id'
], foreignKeys: [
  ForeignKey(
    childColumns: ['plant_id'],
    parentColumns: ['id'],
    entity: Plant,
    onDelete: ForeignKeyAction.cascade
  )
])
class HomeAssistantEntity extends Equatable {
  @ColumnInfo(name: 'entity_id')
  final String entityId;
  @ColumnInfo(name: 'plant_id')
  final int plantId;
  final hass.Entity entity;

  const HomeAssistantEntity(
    this.plantId,
    this.entityId,
    this.entity,
  );

  @override
  List<Object?> get props => [plantId, entityId];
}
