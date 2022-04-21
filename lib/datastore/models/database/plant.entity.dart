import 'package:floor/floor.dart';
import 'package:homsai/datastore/models/database/base.entity.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';

@Entity(tableName: 'Plant', foreignKeys: [
  ForeignKey(
    childColumns: ['configuration_id'],
    parentColumns: ['id'],
    entity: Configuration,
  ),
])
class Plant extends BaseEntity {
  @ColumnInfo(name: 'local_url')
  final String localUrl;
  @ColumnInfo(name: 'remote_url')
  final String remoteUrl;
  final String name;
  final double latitude;
  final double longitude;
  @ColumnInfo(name: 'active')
  final bool isActive;
  @ColumnInfo(name: 'configuration_id')
  final int configurationId;

  @ColumnInfo(name: 'production_sensor_id')
  final String? productionSensor;
  @ColumnInfo(name: 'consumption_sensor_id')
  final String? consumptionSensor;

  String get coordinates => "$latitude;$longitude";

  Plant(
    this.localUrl,
    this.remoteUrl,
    this.name,
    this.latitude,
    this.longitude,
    this.configurationId, {
    int? id,
    this.productionSensor,
    this.consumptionSensor,
    this.isActive = false,
  }) : super(id);

  Plant copyWith({
    bool? isActive,
    String? productionSensor,
    String? consumptionSensor,
  }) =>
      Plant(
        localUrl,
        remoteUrl,
        name,
        latitude,
        longitude,
        configurationId,
        id: id,
        productionSensor: productionSensor ?? this.productionSensor,
        consumptionSensor: consumptionSensor ?? this.consumptionSensor,
        isActive: isActive ?? this.isActive,
      );
}
