import 'dart:convert';

import 'package:floor/floor.dart';

class ListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    return List.castFrom<dynamic, String>(jsonDecode(databaseValue));
  }

  @override
  String encode(List<String> value) {
    return jsonEncode(value);
  }
}
