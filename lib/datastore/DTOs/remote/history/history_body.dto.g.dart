// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryBodyDto _$HistoryBodyDtoFromJson(Map<String, dynamic> json) =>
    HistoryBodyDto(
      json['filter_entity_id'] as String,
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      minimalResponse: const QueryBoolConverter()
          .fromJson(json['minimal_response'] as String),
      significantChangesOnly: const QueryBoolConverter()
          .fromJson(json['significant_changes_only'] as String),
    );

Map<String, dynamic> _$HistoryBodyDtoToJson(HistoryBodyDto instance) {
  final val = <String, dynamic>{
    'filter_entity_id': instance.filterEntityId,
    'end_time': instance.endTime?.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('minimal_response',
      const QueryBoolConverter().toJson(instance.minimalResponse));
  writeNotNull('significant_changes_only',
      const QueryBoolConverter().toJson(instance.significantChangesOnly));
  return val;
}
