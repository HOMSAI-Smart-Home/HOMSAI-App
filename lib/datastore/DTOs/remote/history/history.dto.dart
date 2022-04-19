import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history.dto.g.dart';

@JsonSerializable()
@DateTimeConverter()
class HistoryDto {
  Map<String, dynamic>? attributes;
  @JsonKey(name: 'entity_id')
  String? entityId;
  @JsonKey(name: 'last_changed')
  DateTime lastChanged;
  @JsonKey(name: 'last_updated')
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
}
