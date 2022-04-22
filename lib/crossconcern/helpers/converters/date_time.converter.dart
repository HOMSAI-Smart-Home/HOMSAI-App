import 'package:homsai/main.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:timezone/timezone.dart';

@JsonSerializable()
class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

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
