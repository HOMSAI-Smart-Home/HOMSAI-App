import 'package:json_annotation/json_annotation.dart';

part 'daily_plan.dto.g.dart';

@JsonSerializable()
class DailyPlanDto {
  List<HourDto> dailyPlan = [];

  DailyPlanDto(this.dailyPlan);

  factory DailyPlanDto.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DailyPlanDtoToJson(this);

  DailyPlanDto.fromList(List jsonList) {
    for (var element in jsonList) {
      dailyPlan.add(HourDto.fromList(element));
    }
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
}

@JsonSerializable()
class DeviceDto {
  int? order;
  @JsonKey(name: 'entity_id')
  String? entityId;

  DeviceDto(this.order, this.entityId);

  factory DeviceDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceDtoToJson(this);
}
