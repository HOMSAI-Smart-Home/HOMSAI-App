import 'package:homsai/main.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:timezone/timezone.dart';

class TimezoneDateTimeConverter implements JsonConverter<DateTime, String> {
  const TimezoneDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    Location location = getIt.get<Location>();
    return TZDateTime.from(DateTime.parse(json), location);
  }

  @override
  String toJson(DateTime object) => (object is TZDateTime)
      ? object.toUtc().toIso8601String()
      : object.toIso8601String();
}

class ShortDateTimeConverter implements JsonConverter<DateTime, String> {
  final pattern = 'yyyy-MM-dd';

  const ShortDateTimeConverter();

  @override
  DateTime fromJson(String json) {
    final formatter = DateFormat(pattern);
    return formatter.parse(json);
  }

  @override
  String toJson(DateTime date) {
    final formatter = DateFormat(pattern);
    return formatter.format(date);
  }
}
