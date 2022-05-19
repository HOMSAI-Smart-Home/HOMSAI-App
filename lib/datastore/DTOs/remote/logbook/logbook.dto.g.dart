// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logbook.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogbookDto _$LogbookDtoFromJson(Map<String, dynamic> json) => LogbookDto(
      (json['data'] as List<dynamic>)
          .map((e) => LogDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LogbookDtoToJson(LogbookDto instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
