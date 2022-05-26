// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base.area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
      id: json['area_id'] as String,
      name: json['name'] as String,
      picture: json['picture'],
    );

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'area_id': instance.id,
      'name': instance.name,
      'picture': instance.picture,
    };
