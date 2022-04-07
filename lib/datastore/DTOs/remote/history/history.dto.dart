import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history.dto.g.dart';

@JsonSerializable()
class HistoryDto {
  List<EntitysHistory> entitysHistory = [];

  HistoryDto(this.entitysHistory);

  factory HistoryDto.fromJson(Map<String, dynamic> json) =>
      _$HistoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryDtoToJson(this);

  HistoryDto.fromList(List jsonList) {
    for (var element in jsonList) {
      entitysHistory.add(EntitysHistory.fromList(element));
    }
  }
}

@JsonSerializable()
class EntitysHistory {
  List<ChangeAttribute> changes = [];

  EntitysHistory(this.changes);

  factory EntitysHistory.fromJson(Map<String, dynamic> json) =>
      _$EntitysHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$EntitysHistoryToJson(this);

  EntitysHistory.fromList(List jsonList) {
    for (var element in jsonList) {
      changes.add(ChangeAttribute.fromJson(element));
    }
  }
}

@JsonSerializable()
@DateTimeConverter()
class ChangeAttribute {
  Map<String, dynamic>? attributes;
  @JsonKey(name: 'entity_id')
  String? entityId;
  @JsonKey(name: 'last_changed')
  DateTime lastChanged;
  @JsonKey(name: 'last_updated')
  DateTime? lastUpdated;
  String state;

  ChangeAttribute(
    this.attributes,
    this.entityId,
    this.lastChanged,
    this.lastUpdated,
    this.state,
  );

  factory ChangeAttribute.fromJson(Map<String, dynamic> json) =>
      _$ChangeAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeAttributeToJson(this);
}
