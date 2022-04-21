// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_assistant_auth.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeAssistantAuth _$HomeAssistantAuthFromJson(Map<String, dynamic> json) =>
    HomeAssistantAuth(
      json['localUrl'] as String,
      json['remoteUrl'] as String,
      json['token'] as String,
      json['expires'] as int,
      json['refreshToken'] as String,
      json['tokenType'] as String,
    );

Map<String, dynamic> _$HomeAssistantAuthToJson(HomeAssistantAuth instance) =>
    <String, dynamic>{
      'localUrl': instance.localUrl,
      'remoteUrl': instance.remoteUrl,
      'token': instance.token,
      'expires': instance.expires,
      'refreshToken': instance.refreshToken,
      'tokenType': instance.tokenType,
    };
