import 'package:floor/floor.dart';
import 'package:homsai/datastore/models/database/base.entity.dart';
import 'package:homsai/datastore/models/database/configuration.entity.dart';

@Entity(tableName: 'Plant', foreignKeys: [
  ForeignKey(
      childColumns: ['configuration_id'],
      parentColumns: ['id'],
      entity: Configuration,
      onDelete: ForeignKeyAction.cascade),
])
class Plant extends BaseEntity {
  @ColumnInfo(name: 'local_url')
  final String? localUrl;
  @ColumnInfo(name: 'remote_url')
  final String? remoteUrl;
  final String name;
  final double latitude;
  final double longitude;
  @ColumnInfo(name: 'configuration_id')
  final int configurationId;

  @ColumnInfo(name: 'production_sensor_id')
  final String? productionSensor;
  @ColumnInfo(name: 'consumption_sensor_id')
  final String? consumptionSensor;
  @ColumnInfo(name: 'photovoltaic_nominal_power')
  final double? photovoltaicNominalPower;
  @ColumnInfo(name: 'photovoltaic_installation_date')
  final DateTime? photovoltaicInstallationDate;
  @ColumnInfo(name: 'battery_sensor_id')
  final String? batterySensor;

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
    this.photovoltaicNominalPower,
    this.photovoltaicInstallationDate,
    this.batterySensor,
  }) : super(id);

  bool get canShowConsumptionOptimization =>
      productionSensor != null && consumptionSensor != null;

  bool get canShowPhotovoltaicForecast =>
      photovoltaicNominalPower != null && photovoltaicInstallationDate != null;

  Plant copyWith({
    String? localUrl,
    String? remoteUrl,
    String? name,
    double? latitude,
    double? longitude,
    int? configurationId,
    String? productionSensor,
    String? consumptionSensor,
    double? photovoltaicNominalPower,
    DateTime? photovoltaicInstallationDate,
    String? batterySensor,
  }) =>
      Plant(
        localUrl == null
            ? this.localUrl
            : localUrl.isEmpty
                ? null
                : localUrl,
        remoteUrl == null
            ? this.remoteUrl
            : remoteUrl.isEmpty
                ? null
                : remoteUrl,
        name ?? this.name,
        latitude ?? this.latitude,
        longitude ?? this.longitude,
        configurationId ?? this.configurationId,
        id: id,
        productionSensor: parseSensor(productionSensor, this.productionSensor),
        consumptionSensor:
            parseSensor(consumptionSensor, this.consumptionSensor),
        photovoltaicInstallationDate:
            photovoltaicInstallationDate ?? this.photovoltaicInstallationDate,
        photovoltaicNominalPower:
            photovoltaicNominalPower ?? this.photovoltaicNominalPower,
        batterySensor: parseSensor(batterySensor, this.batterySensor),
      );

  String? parseSensor(String? newSensor, String? defaultSensor) {
    final sensor = newSensor ?? defaultSensor;
    return sensor != null && sensor.isEmpty ? null : sensor;
  }

  Uri getBaseUrl() {
    return localUrl != null ? Uri.parse(localUrl!) : Uri.parse(remoteUrl!);
  }

  Uri? getFallbackUrl() {
    return localUrl != null && remoteUrl != null
        ? Uri.parse(remoteUrl ?? '')
        : null;
  }
}
