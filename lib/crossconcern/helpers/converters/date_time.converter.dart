import 'package:homsai/crossconcern/helpers/extensions/date_time.extension.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DateTimeConverter implements JsonConverter<DateTime, String> {

  const DateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => object.formatHA;
}