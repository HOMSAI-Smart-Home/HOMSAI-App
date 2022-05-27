import 'package:homsai/crossconcern/utilities/util/anonimizer.util.dart';
import 'package:json_annotation/json_annotation.dart';

part 'daily_plan.dto.g.dart';

@JsonSerializable()
class DailyPlanDto {
  List<HourDto> dailyPlan = [];

  DailyPlanDto(this.dailyPlan);

  DailyPlanDto decipher(Anonymizer anonymizer) =>
      DailyPlanDto(dailyPlan.map((plan) => plan.decipher(anonymizer)).toList());

  factory DailyPlanDto.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DailyPlanDtoToJson(this);

  static List<HourDto> fromList(List<dynamic> results) {
    return results.map((result) => HourDto.fromJson(result)).toList();
  }

  factory DailyPlanDto.fromResult(List<dynamic> result) {
    return DailyPlanDto(DailyPlanDto.fromList(result));
  }
}

@JsonSerializable()
class HourDto {
  String? hour;
  @JsonKey(name: 'device_id')
  List<DeviceDto> deviceId = [];

  HourDto(this.hour, this.deviceId);

  factory HourDto.fromJson(Map<String, dynamic> json) =>
      _$HourDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HourDtoToJson(this);

  HourDto.fromList(List jsonList) {
    for (var element in jsonList) {
      deviceId.add(DeviceDto.fromJson(element));
    }
  }

  HourDto decipher(Anonymizer anonymizer) => copyWith(
        deviceId:
            deviceId.map((device) => device.decipher(anonymizer)).toList(),
      );

  HourDto copyWith({
    String? hour,
    List<DeviceDto>? deviceId,
  }) =>
      HourDto(hour ?? this.hour, deviceId ?? this.deviceId);
}

@JsonSerializable()
class DeviceDto {
  int? order;
  @JsonKey(name: 'device_id')
  String? entityId;

  DeviceDto(this.order, this.entityId);

  factory DeviceDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDtoToJson(this);

  DeviceDto decipher(Anonymizer anonymizer) {
    List<String> entity = entityId?.split('.') ?? List.empty();
    return copyWith(
      entityId: anonymizer.decipherAll(entity).join("."),
    );
  }

  DeviceDto copyWith({
    int? order,
    String? entityId,
  }) =>
      DeviceDto(order ?? this.order, entityId ?? this.entityId);
}
