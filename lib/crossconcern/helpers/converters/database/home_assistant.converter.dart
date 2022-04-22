import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant_entity.factory.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart' as hass;

class HomeAssistantConverter extends TypeConverter<hass.Entity, String> {
  @override
  hass.Entity decode(String databaseValue) {
    return HomeAssistantEntityFactory.parseFromJson(jsonDecode(databaseValue));
  }

  @override
  String encode(hass.Entity value) {
    return jsonEncode(value);
  }
}
