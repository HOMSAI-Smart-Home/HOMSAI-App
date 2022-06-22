import 'dart:convert';

import 'package:flutter/services.dart';

Future<dynamic> readJson(path) async {
  final String response = await rootBundle.loadString(path);
  return await jsonDecode(response);
}
