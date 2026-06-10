import 'package:freezed_annotation/freezed_annotation.dart';

part 'slot.freezed.dart';
part 'slot.g.dart';

/// Slot model — a time slot at a venue on a specific date.
///
/// Maps to GET /venues/:id/slots response.
/// isBooked and bookedByUserId come from LEFT JOIN with bookings table.
@freezed
abstract class Slot with _$Slot {
  const factory Slot({
    required String id,
    required String venueId,
    required String date,
    required String startTime,
    required String endTime,
    required bool isBooked,
    String? bookedByUserId,
  }) = _Slot;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);
}
