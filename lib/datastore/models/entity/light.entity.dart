import 'package:equatable/equatable.dart';
import 'package:homsai/datastore/models/entity/entity.entity.model.dart';
import 'package:homsai/datastore/models/entity/toggle.entity.model.dart';

class LightEntity extends Entity with ToggableEntity, EquatableMixin {
  String? name;
  int? brightness;
  String? colorMode;
  int? colorTemp;
  String? effect;
  List? effectList;
  List<dynamic>? hsColor;
  late int maxMireds;
  late int minMireds;
  List<dynamic>? rgbColor;
  List<dynamic>? rgbwColor;
  List<dynamic>? rgbwwColor;
  List<dynamic>? supportedColorModes;
  late int supportedFeatures;
  List<dynamic>? xyColor;

  late String id;

  LightEntity.fromJson(Map<String, dynamic> entity) {
    entityId = entity['entity_id'];
    state = entity['state'];
    isOn = state == 'on';

    Map<String, dynamic>? attributes =
        entity.containsKey('attributes') ? entity['attributes'] : null;
    if (attributes != null) {
      brightness = attributes.containsKey('brightness')
          ? attributes['brightness']
          : null;
      friendlyName = attributes.containsKey('friendly_name')
          ? attributes['friendly_name']
          : null;
      colorMode = attributes.containsKey('color_mode')
          ? attributes['color_mode']
          : null;
      colorTemp = attributes.containsKey('color_temp')
          ? attributes['color_temp']
          : null;
      effect = attributes.containsKey('effect') ? attributes['effect'] : null;
      effectList = attributes.containsKey('effect_list')
          ? attributes['effect_list']
          : null;
      hsColor =
          attributes.containsKey('hs_color') ? attributes['hs_color'] : null;
      maxMireds =
          attributes.containsKey('max_mireds') ? attributes['max_mireds'] : 500;
      minMireds =
          attributes.containsKey('min_mireds') ? attributes['min_mireds'] : 153;
      rgbColor =
          attributes.containsKey('rgb_color') ? attributes['rgb_color'] : null;
      rgbwColor = attributes.containsKey('rgbw_color')
          ? attributes['rgbw_color']
          : null;
      rgbwwColor = attributes.containsKey('rgbww_color')
          ? attributes['rgbww_color']
          : null;
      supportedColorModes = attributes.containsKey('supported_color_modes')
          ? attributes['supported_color_modes']
          : null;
      supportedFeatures = attributes.containsKey('supported_features')
          ? attributes['supported_features']
          : 0;
      xyColor =
          attributes.containsKey('xy_color') ? attributes['xy_color'] : null;
    }

    Map<String, dynamic> context = entity['context'];
    id = context['id'];
  }

  Map<String, String> toJson() {
    Map<String, String> attributes = {};

    brightness != null
        ? attributes['brightness'] = brightness.toString()
        : null;
    colorMode != null ? attributes['color_mode'] = colorMode.toString() : null;
    colorTemp != null ? attributes['color_temp'] = colorTemp.toString() : null;
    effect != null ? attributes['effect'] = effect.toString() : null;
    effectList != null
        ? attributes['effect_list'] = effectList.toString()
        : null;
    hsColor != null ? attributes['hs_color'] = hsColor.toString() : null;
    attributes['max_mireds'] = maxMireds.toString();
    attributes['min_mireds'] = minMireds.toString();
    rgbColor != null ? attributes['rgb_color'] = rgbColor.toString() : null;
    rgbwColor != null ? attributes['rgbw_color'] = rgbwColor.toString() : null;
    rgbwwColor != null
        ? attributes['rgbww_color'] = rgbwwColor.toString()
        : null;
    supportedColorModes != null
        ? attributes['supported_color_modes'] = supportedColorModes.toString()
        : null;
    attributes['supported_features'] = supportedFeatures.toString();
    xyColor != null ? attributes['xy_color'] = xyColor.toString() : null;
    friendlyName != null
        ? attributes['friendly_name'] = friendlyName.toString()
        : null;

    return attributes;
  }

  LightEntity copy() {
    return LightEntity.fromJson({
      'entity_id': entityId,
      'state': isOn ? 'on' : 'off',
      "attributes": {"friendly_name": friendlyName},
      "context": {'id': id}
    });
  }

  @override
  List<Object?> get props => [entityId, id, isOn];
}
