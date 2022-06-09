import 'package:json_annotation/json_annotation.dart';

part 'photovoltaic_body.dto.g.dart';

@JsonSerializable()
class PhotovoltaicForecastBodyDto {
  final int days;
  final double kwp;

  @JsonKey(name: "lat")
  final double latitude;
  @JsonKey(name: "lng")
  final double longitude;
  @JsonKey(name: "plant_life_days")
  final int plantLifeDays;

  PhotovoltaicForecastBodyDto(
    this.kwp,
    this.plantLifeDays, {
    this.days = 3,
    required this.latitude,
    required this.longitude,
  });

  factory PhotovoltaicForecastBodyDto.fromJson(Map<String, dynamic> json) =>
      _$PhotovoltaicForecastBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotovoltaicForecastBodyDtoToJson(this);
}
