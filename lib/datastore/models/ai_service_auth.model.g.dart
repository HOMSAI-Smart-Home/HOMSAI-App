// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_service_auth.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AiServiceAuth _$AiServiceAuthFromJson(Map<String, dynamic> json) =>
    AiServiceAuth(
      json['token'] as String?,
      json['refreshToken'] as String?,
    );

Map<String, dynamic> _$AiServiceAuthToJson(AiServiceAuth instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
