import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

/// Venue model — a sports facility with courts/turfs.
///
/// Maps to GET /venues response.
@freezed
abstract class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String name,
    required String location,
    required String sportType,
    String? imageUrl,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}
