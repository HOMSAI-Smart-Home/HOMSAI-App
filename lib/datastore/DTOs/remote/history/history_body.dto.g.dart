// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryBodyDto _$HistoryBodyDtoFromJson(Map<String, dynamic> json) =>
    HistoryBodyDto(
      json['start'] == null ? null : DateTime.parse(json['start'] as String),
      json['filter_entity_id'] as String?,
      json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      json['minimal_response'] as bool?,
      json['significant_changes_only'] as bool?,
    );

Map<String, dynamic> _$HistoryBodyDtoToJson(HistoryBodyDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('start', instance.start?.toIso8601String());
  val['filter_entity_id'] = instance.filterEntityId;
  val['end_time'] = instance.endTime?.toIso8601String();
  val['minimal_response'] = instance.minimalResponse;
  val['significant_changes_only'] = instance.significantChangesOnly;
  return val;
}
