import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:homsai/crossconcern/helpers/converters/query_bool.converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_body.dto.g.dart';

@JsonSerializable()
@DateTimeConverter()
@QueryBoolConverter()
class HistoryBodyDto {
  @JsonKey(ignore: true)
  DateTime? start;
  @JsonKey(name: 'filter_entity_id')
  String filterEntityId;
  @JsonKey(name: 'end_time')
  DateTime? endTime;
  @JsonKey(name: 'no_attributes', includeIfNull: false)
  bool? noAttributes;
  @JsonKey(name: 'minimal_response', includeIfNull: false)
  bool? minimalResponse;
  @JsonKey(
    name: 'significant_changes_only',
    includeIfNull: false,
  )
  bool? significantChangesOnly;

  HistoryBodyDto(
    this.filterEntityId, {
    this.start,
    this.endTime,
    this.noAttributes,
    this.minimalResponse,
    this.significantChangesOnly,
  }) {
    final now = DateTime.now();
    start ??= DateTime(now.year, now.month, now.day - 1, 0, 0);
    endTime ??= DateTime(now.year, now.month, now.day, 0, 0);
  }

  factory HistoryBodyDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryBodyDtoToJson(this);
}
