import 'package:homsai/crossconcern/helpers/extensions/date_time.extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_body.dto.g.dart';

@JsonSerializable()
@DateTimeConverter()
class HistoryBodyDto {
  @JsonKey(toJson: null, includeIfNull: false)
  DateTime? start;
  @JsonKey(name: 'filter_entity_id')
  String? filterEntityId;
  @JsonKey(name: 'end_time')
  DateTime? endTime;
  @JsonKey(name: 'minimal_response')
  bool? minimalResponse;
  @JsonKey(name: 'significant_changes_only')
  bool? significantChangesOnly;

  HistoryBodyDto(
    this.start,
    this.filterEntityId,
    this.endTime,
    this.minimalResponse,
    this.significantChangesOnly,
  );

  factory HistoryBodyDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryBodyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryBodyDtoToJson(this);
}

@JsonSerializable()
class DateTimeConverter implements JsonConverter<DateTime, String> {

  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.formatHA;
}
