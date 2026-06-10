// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookingImpl _$$BookingImplFromJson(Map<String, dynamic> json) =>
    _$BookingImpl(
      id: json['id'] as String,
      slotId: json['slotId'] as String,
      status: json['status'] as String,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] as String?,
      slot: json['slot'] == null
          ? null
          : BookingSlotInfo.fromJson(json['slot'] as Map<String, dynamic>),
      venue: json['venue'] == null
          ? null
          : BookingVenueInfo.fromJson(json['venue'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BookingImplToJson(_$BookingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slotId': instance.slotId,
      'status': instance.status,
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'slot': instance.slot,
      'venue': instance.venue,
    };

_$BookingSlotInfoImpl _$$BookingSlotInfoImplFromJson(
  Map<String, dynamic> json,
) => _$BookingSlotInfoImpl(
  date: json['date'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
);

Map<String, dynamic> _$$BookingSlotInfoImplToJson(
  _$BookingSlotInfoImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
};

_$BookingVenueInfoImpl _$$BookingVenueInfoImplFromJson(
  Map<String, dynamic> json,
) => _$BookingVenueInfoImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  sportType: json['sportType'] as String,
  location: json['location'] as String?,
);

Map<String, dynamic> _$$BookingVenueInfoImplToJson(
  _$BookingVenueInfoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'sportType': instance.sportType,
  'location': instance.location,
};
