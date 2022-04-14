// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logbook_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogbookBodyDto _$LogbookBodyDtoFromJson(Map<String, dynamic> json) =>
    LogbookBodyDto(
      start: json['start'] == null
          ? null
          : DateTime.parse(json['start'] as String),
      entity: json['entity'] as String?,
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
    );

Map<String, dynamic> _$LogbookBodyDtoToJson(LogbookBodyDto instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('start', instance.start?.toIso8601String());
  val['entity'] = instance.entity;
  val['end_time'] = instance.endTime?.toIso8601String();
  return val;
}
