import 'package:homsai/datastore/models/entity/sensors/mesurable/mesurable_sensor.entity.dart';
import 'package:homsai/datastore/models/entity/sensors/sensor.entity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonEnum(fieldRename: FieldRename.snake)
enum DeviceClass {
  unknown,
  apparentPower,
  aqi,
  battery,
  carbonDioxide,
  carbonMonoxide,
  current,
  date,
  energy,
  frequency,
  gas,
  humidity,
  illuminance,
  monetary,
  nitrogenDioxide,
  nitrogenMonoxide,
  nitrousOxide,
  ozone,
  pm1,
  pm25,
  pm10,
  power,
  powerFactor,
  pressure,
  reactivePower,
  signalStrength,
  sulphurDioxide,
  temperature,
  timestamp,
  volatileOrganicCompounds,
  voltage,

  connectivity,
  update,
  plug,
  window
}

extension DeviceClassX on DeviceClass {
  bool get isUnknown => this == DeviceClass.unknown;
  bool get isNotUnknown => this != DeviceClass.unknown;
}

class HomeAssistantSensorFactory {
  static final Map<DeviceClass, List<String>> unitsMesurements = {
    DeviceClass.apparentPower: ["VA"],
    DeviceClass.battery: ["%"],
    DeviceClass.carbonDioxide: ["ppm"],
    DeviceClass.carbonMonoxide: ["ppm"],
    DeviceClass.current: ["A"],
    DeviceClass.energy: ["Wh", "kWh", "MWh"],
    DeviceClass.frequency: ["Hz", "kHz", "MHz", "GHz"],
    DeviceClass.gas: ["m³", "ft³"],
    DeviceClass.humidity: ["%"],
    DeviceClass.illuminance: ["lx", "lm"],
    DeviceClass.nitrogenDioxide: ["µg/m³"],
    DeviceClass.nitrogenMonoxide: ["µg/m³"],
    DeviceClass.nitrousOxide: ["µg/m³"],
    DeviceClass.ozone: ["µg/m³"],
    DeviceClass.pm1: ["µg/m³"],
    DeviceClass.pm25: ["µg/m³"],
    DeviceClass.pm10: ["µg/m³"],
    DeviceClass.power: ["W", "kW"],
    DeviceClass.powerFactor: ["%"],
    DeviceClass.pressure: [
      "cbar",
      "bar",
      "hPa",
      "inHg",
      "kPa",
      "mbar",
      "Pa",
      "psi",
    ],
    DeviceClass.reactivePower: ["var"],
    DeviceClass.signalStrength: ["dB", "dBm"],
    DeviceClass.sulphurDioxide: ["µg/m³"],
    DeviceClass.temperature: ["°C", "°F"],
    DeviceClass.volatileOrganicCompounds: ["µg/m³"],
    DeviceClass.voltage: ["V"]
  };

  static bool isDeviceClassOf(
    DeviceClass deviceClass,
    SensorEntity sensorEntity,
  ) {
    if (sensorEntity.deviceClass.isNotUnknown) {
      return sensorEntity.deviceClass == deviceClass;
    }
    if (sensorEntity is MesurableSensorEntity) {
      return unitsMesurements[deviceClass]
              ?.contains(sensorEntity.unitMesurement) ??
          false;
    }
    return false;
  }

  static Type getSensorType(Map<String, dynamic> attributes) {
    if (attributes.containsKey('unit_of_measurement')) {
      return MesurableSensorEntity;
    }
    return SensorEntity;
  }
}
