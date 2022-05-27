// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_related_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceRelatedBodyDto _$DeviceRelatedBodyDtoFromJson(
        Map<String, dynamic> json) =>
    DeviceRelatedBodyDto(
      json['item_id'] as String,
      itemType: json['item_type'] as String? ?? "device",
    );

Map<String, dynamic> _$DeviceRelatedBodyDtoToJson(
        DeviceRelatedBodyDto instance) =>
    <String, dynamic>{
      'item_type': instance.itemType,
      'item_id': instance.itemId,
    };
