// ignore_for_file: overridden_fields

import 'package:equatable/equatable.dart';
import 'package:homsai/datastore/models/entity/attributes/attributes.entity.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart';
import 'package:homsai/datastore/models/entity/context/context.entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'light.entity.g.dart';

@JsonSerializable()
class LightEntity extends Entity with TogglableEntity, EquatableMixin {
  static const String type = "light";

  @override
  covariant LightAttributes attributes;

  LightEntity(
    String entityId,
    String state,
    this.attributes,
    DateTime lastChanged,
    DateTime lastUpdated,
    ContextEntity context,
  ) : super(
          entityId,
          state,
          attributes,
          lastChanged,
          lastUpdated,
          context,
        );

  factory LightEntity.fromJson(Map<String, dynamic> json) =>
      _$LightEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LightEntityToJson(this);

  LightEntity copy() {
    return LightEntity.fromJson(toJson());
  }

  @override
  List<Object?> get props => [entityId, state];
}

@JsonSerializable()
class LightAttributes extends Attributes {
  @JsonKey(name: 'color_mode')
  String? colorMode;
  @JsonKey(name: 'color_temp')
  int? colorTemp;
  int? brightness;

  String? effect;
  @JsonKey(name: 'effect_list')
  List? effectList;

  @JsonKey(name: 'hs_color')
  List<dynamic>? hsColor;

  @JsonKey(name: 'max_mireds')
  int? maxMireds;
  @JsonKey(name: 'min_mireds')
  int? minMireds;

  @JsonKey(name: 'xy_color')
  List<dynamic>? xyColor;
  @JsonKey(name: 'rgb_color')
  List<dynamic>? rgbColor;
  @JsonKey(name: 'rgbw_color')
  List<dynamic>? rgbwColor;
  @JsonKey(name: 'rgbww_color')
  List<dynamic>? rgbwwColor;

  @JsonKey(name: 'supported_color_modes')
  List<dynamic>? supportedColorModes;
  @JsonKey(name: 'supported_features')
  int? supportedFeatures;

  LightAttributes(String friendlyName) : super(friendlyName);

  factory LightAttributes.fromJson(Map<String, dynamic> json) =>
      _$LightAttributesFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LightAttributesToJson(this);
}
