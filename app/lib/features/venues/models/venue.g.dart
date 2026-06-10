// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueImpl _$$VenueImplFromJson(Map<String, dynamic> json) => _$VenueImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  location: json['location'] as String,
  sportType: json['sportType'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$VenueImplToJson(_$VenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'sportType': instance.sportType,
      'imageUrl': instance.imageUrl,
    };
