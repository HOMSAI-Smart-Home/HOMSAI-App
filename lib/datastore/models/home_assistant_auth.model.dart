import 'package:json_annotation/json_annotation.dart';

part 'home_assistant_auth.model.g.dart';

@JsonSerializable()
class HomeAssistantAuth {
  String token;
  int expires;
  String refreshToken;
  String tokenType;

  HomeAssistantAuth(
    this.token,
    this.expires,
    this.refreshToken,
    this.tokenType,
  );

  factory HomeAssistantAuth.fromJson(Map<String, dynamic> json) =>
      _$HomeAssistantAuthFromJson(json);

  Map<String, dynamic> toJson() => _$HomeAssistantAuthToJson(this);
}
