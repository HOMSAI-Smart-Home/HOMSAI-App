import 'package:fl_chart/fl_chart.dart';
import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photovoltaic.dto.g.dart';

@JsonSerializable()
@ShortDateTimeConverter()
class PhotovoltaicForecastDto {
  final DateTime date;
  final double production;
  @JsonKey(name: "minutes_in_day")
  final int minutesInDay;

  PhotovoltaicForecastDto(
    this.date,
    this.production,
    this.minutesInDay,
  );

  factory PhotovoltaicForecastDto.fromJson(Map<String, dynamic> json) =>
      _$PhotovoltaicForecastDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotovoltaicForecastDtoToJson(this);

  static List<PhotovoltaicForecastDto> fromList(List<dynamic> results) {
    return results
        .map((result) => PhotovoltaicForecastDto.fromJson(result))
        .toList();
  }

  FlSpot get toSpot => FlSpot(
      date
          .add(Duration(minutes: minutesInDay))
          .millisecondsSinceEpoch
          .toDouble(),
      production);
}
