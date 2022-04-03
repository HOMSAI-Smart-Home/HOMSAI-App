import 'package:json_annotation/json_annotation.dart';

part 'context.entity.g.dart';

@JsonSerializable()
class ContextEntity {
  String id;
  @JsonKey(name: 'parent_id')
  String? parentId;
  @JsonKey(name: 'user_id')
  String? userId;

  ContextEntity(this.id, this.parentId, this.userId);

  factory ContextEntity.fromJson(Map<String, dynamic> json) =>
      _$ContextEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ContextEntityToJson(this);
}
