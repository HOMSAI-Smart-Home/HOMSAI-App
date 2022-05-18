// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photovoltaic_body.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotovoltaicForecastBodyDto _$PhotovoltaicForecastBodyDtoFromJson(
        Map<String, dynamic> json) =>
    PhotovoltaicForecastBodyDto(
      (json['kwp'] as num).toDouble(),
      json['plant_life_days'] as int,
      days: json['days'] as int? ?? 2,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$PhotovoltaicForecastBodyDtoToJson(
        PhotovoltaicForecastBodyDto instance) =>
    <String, dynamic>{
      'days': instance.days,
      'kwp': instance.kwp,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'plant_life_days': instance.plantLifeDays,
    };
