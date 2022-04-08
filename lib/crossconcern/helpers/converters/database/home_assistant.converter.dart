import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:homsai/crossconcern/helpers/factories/home_assistant.factory.dart';
import 'package:homsai/datastore/models/entity/base/base.entity.dart'
    as home_assistant;

class HomeAssistantConverter
    extends TypeConverter<home_assistant.Entity, String> {
  @override
  home_assistant.Entity decode(String databaseValue) {
    return HomeAssistantEntityFactory.parseFromJson(jsonDecode(databaseValue));
  }

  @override
  String encode(home_assistant.Entity value) {
    return jsonEncode(value);
  }
}
