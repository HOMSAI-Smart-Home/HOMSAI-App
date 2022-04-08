import 'package:floor/floor.dart';
import 'package:homsai/datastore/models/database/base.entity.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';

@Entity(tableName: 'Plant', foreignKeys: [
  ForeignKey(
    childColumns: ['configuration_id'],
    parentColumns: ['id'],
    entity: Configuration,
  )
])
class Plant extends BaseEntity {
  final String url;
  @ColumnInfo(name: 'remote')
  final bool isUrlRemote;
  final String name;
  final String email;
  final double latitude;
  final double longitude;
  @ColumnInfo(name: 'active')
  final bool isActive;
  @ColumnInfo(name: 'configuration_id')
  final int configurationId;

  String get coordinates => "$latitude;$longitude";

  Plant(
    this.url,
    this.name,
    this.email,
    this.latitude,
    this.longitude,
    this.configurationId, {
    int? id,
    this.isUrlRemote = false,
    this.isActive = false,
  }) : super(id);

  Plant copyWith({
    bool? isActive,
  }) =>
      Plant(url, name, email, latitude, longitude, configurationId,
          id: id, isActive: isActive ?? this.isActive);
}
