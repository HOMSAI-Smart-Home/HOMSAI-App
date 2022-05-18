// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photovoltaic.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotovoltaicForecastDto _$PhotovoltaicForecastDtoFromJson(
        Map<String, dynamic> json) =>
    PhotovoltaicForecastDto(
      const ShortDateTimeConverter().fromJson(json['date'] as String),
      (json['production'] as num).toDouble(),
      json['minutes_in_day'] as int,
    );

Map<String, dynamic> _$PhotovoltaicForecastDtoToJson(
        PhotovoltaicForecastDto instance) =>
    <String, dynamic>{
      'date': const ShortDateTimeConverter().toJson(instance.date),
      'production': instance.production,
      'minutes_in_day': instance.minutesInDay,
    };
