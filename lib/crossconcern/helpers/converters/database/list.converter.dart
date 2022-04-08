import 'dart:convert';

import 'package:floor/floor.dart';

class ListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    return jsonDecode(databaseValue);
  }

  @override
  String encode(List<String> value) {
    return jsonEncode(value);
  }
}
