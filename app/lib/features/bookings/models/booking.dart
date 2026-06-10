import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// Booking model — a user's booking of a specific slot.
///
/// For POST /bookings response (simple):
///   { id, userId, slotId, status }
///
/// For GET /users/:id/bookings response (with nested venue/slot details):
///   { id, slotId, status, createdAt, slot: {...}, venue: {...} }
@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,
    required String slotId,
    required String status,
    String? userId,
    String? createdAt,
    BookingSlotInfo? slot,
    BookingVenueInfo? venue,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

/// Nested slot info within a booking response.
@freezed
abstract class BookingSlotInfo with _$BookingSlotInfo {
  const factory BookingSlotInfo({
    required String date,
    required String startTime,
    required String endTime,
  }) = _BookingSlotInfo;

  factory BookingSlotInfo.fromJson(Map<String, dynamic> json) =>
      _$BookingSlotInfoFromJson(json);
}

/// Nested venue info within a booking response.
@freezed
abstract class BookingVenueInfo with _$BookingVenueInfo {
  const factory BookingVenueInfo({
    required String id,
    required String name,
    required String sportType,
    String? location,
  }) = _BookingVenueInfo;

  factory BookingVenueInfo.fromJson(Map<String, dynamic> json) =>
      _$BookingVenueInfoFromJson(json);
}
