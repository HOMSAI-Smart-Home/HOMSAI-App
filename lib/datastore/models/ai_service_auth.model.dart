import 'package:json_annotation/json_annotation.dart';

part 'ai_service_auth.model.g.dart';

@JsonSerializable()
class AiServiceAuth {
  String? token;
  String? refreshToken;

  AiServiceAuth({this.token, this.refreshToken});

  factory AiServiceAuth.fromJson(Map<String, dynamic> json) =>
      _$AiServiceAuthFromJson(json);

  Map<String, dynamic> toJson() => _$AiServiceAuthToJson(this);

  AiServiceAuth copyWith({
    String? token,
    String? refreshToken,
  }) {
    return AiServiceAuth(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
