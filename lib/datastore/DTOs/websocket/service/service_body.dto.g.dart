// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceBodyDto _$ServiceBodyDtoFromJson(Map<String, dynamic> json) =>
    ServiceBodyDto(
      json['serviceData'] as Map<String, dynamic>?,
      json['target'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ServiceBodyDtoToJson(ServiceBodyDto instance) =>
    <String, dynamic>{
      'serviceData': instance.serviceData,
      'target': instance.target,
    };
