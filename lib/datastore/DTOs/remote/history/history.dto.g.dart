// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryDto _$HistoryDtoFromJson(Map<String, dynamic> json) => HistoryDto(
      json['attributes'] as Map<String, dynamic>?,
      json['entity_id'] as String?,
      const TimezoneDateTimeConverter()
          .fromJson(json['last_changed'] as String),
      json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
      json['state'] as String,
    );

Map<String, dynamic> _$HistoryDtoToJson(HistoryDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('attributes', instance.attributes);
  writeNotNull('entity_id', instance.entityId);
  val['last_changed'] =
      const TimezoneDateTimeConverter().toJson(instance.lastChanged);
  writeNotNull('last_updated', instance.lastUpdated?.toIso8601String());
  val['state'] = instance.state;
  return val;
}
