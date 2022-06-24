import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history.dto.g.dart';

@JsonSerializable()
@TimezoneDateTimeConverter()
class HistoryDto {
  @JsonKey(includeIfNull: false)
  Map<String, dynamic>? attributes;
  @JsonKey(name: 'entity_id', includeIfNull: false)
  String? entityId;
  @JsonKey(name: 'last_changed')
  DateTime lastChanged;
  @JsonKey(name: 'last_updated', includeIfNull: false)
  DateTime? lastUpdated;
  String state;

  HistoryDto(
    this.attributes,
    this.entityId,
    this.lastChanged,
    this.lastUpdated,
    this.state,
  );

  factory HistoryDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDtoToJson(this);

  static List<HistoryDto> fromList(List<dynamic> results) {
    return results.map((result) => HistoryDto.fromJson(result)).toList();
  }

  FlSpot get spot => FlSpot(
        (lastChanged.minute + lastChanged.hour * Duration.minutesPerHour)
            .toDouble(),
        max(0, double.tryParse(state) ?? double.negativeInfinity),
      );
}
