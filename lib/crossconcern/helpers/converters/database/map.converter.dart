import 'dart:convert';

import 'package:floor/floor.dart';

class MapConverter extends TypeConverter<Map<String, String>, String> {
  @override
  Map<String, String> decode(String databaseValue) {
    return Map<String, String>.from(jsonDecode(databaseValue));
  }

  @override
  String encode(Map<String, String> value) {
    return jsonEncode(value);
  }
}
