import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class QueryBoolConverter implements JsonConverter<bool?, String> {
  const QueryBoolConverter();

  @override
  bool? fromJson(String json) => json == "true";

  @override
  String toJson(bool? object) => object.toString();
}
