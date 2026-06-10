// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SlotImpl _$$SlotImplFromJson(Map<String, dynamic> json) => _$SlotImpl(
  id: json['id'] as String,
  venueId: json['venueId'] as String,
  date: json['date'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  isBooked: json['isBooked'] as bool,
  bookedByUserId: json['bookedByUserId'] as String?,
);

Map<String, dynamic> _$$SlotImplToJson(_$SlotImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueId': instance.venueId,
      'date': instance.date,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isBooked': instance.isBooked,
      'bookedByUserId': instance.bookedByUserId,
    };
