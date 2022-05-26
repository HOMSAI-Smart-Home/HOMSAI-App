import 'package:json_annotation/json_annotation.dart';

part 'suggestions_chart.dto.g.dart';

@JsonSerializable()
class SuggestionsChartDto {
  @JsonKey(name: "chart")
  final String? chart;

  SuggestionsChartDto(this.chart);

  factory SuggestionsChartDto.fromJson(Map<String, dynamic> json) =>
      _$SuggestionsChartDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestionsChartDtoToJson(this);
}
