import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/venue.dart';
import '../models/slot.dart';
import '../repository/venue_repository.dart';

/// Provider that fetches all venues from the backend.
///
/// Uses FutureProvider for automatic loading/error/data states.
/// The UI uses AsyncValue.when() to handle all three states.
final venuesProvider = FutureProvider<List<Venue>>((ref) async {
  final repository = ref.read(venueRepositoryProvider);
  return repository.getVenues();
});

/// Provider that fetches slots for a venue on a specific date.
///
/// Uses FutureProvider.family to parameterize by venueId + date.
/// Key format: "venueId|date" (e.g., "venue-1|2026-06-10")
///
/// Why .family? Because we need different slot lists for different
/// venue+date combinations, and Riverpod caches them separately.
final slotsProvider =
    FutureProvider.family<List<Slot>, String>((ref, key) async {
  final parts = key.split('|');
  final venueId = parts[0];
  final date = parts[1];
  final repository = ref.read(venueRepositoryProvider);
  return repository.getSlots(venueId, date);
});
