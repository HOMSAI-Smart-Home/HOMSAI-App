import 'package:homsai/crossconcern/helpers/converters/date_time.converter.dart';
import 'package:homsai/crossconcern/utilities/util/anonimizer.util.dart';
import 'package:json_annotation/json_annotation.dart';
part 'log.dto.g.dart';

@JsonSerializable()
@DateTimeConverter()
class LogDto {
  String? state;
  @JsonKey(name: 'entity_id')
  String? entityId;
  String? name;
  DateTime when;

  LogDto(
    this.state,
    this.entityId,
    this.name,
    this.when,
  );

  LogDto cipher(Anonymizer anonimizer) {
    List<String> entity = entityId?.split('.') ?? List.empty();
    return copyWith(
      name: (name != null) ? anonimizer.cipher(name!) : null,
      entityId:
          (entity.isNotEmpty) ? anonimizer.cipherAll(entity).join(".") : null,
    );
  }

  LogDto copyWith({
    String? state,
    String? entityId,
    String? name,
    DateTime? when,
  }) =>
      LogDto(state ?? this.state, entityId ?? this.entityId, name ?? this.name,
          when ?? this.when);

  factory LogDto.fromJson(Map<String, dynamic> json) => _$LogDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LogDtoToJson(this);
}
