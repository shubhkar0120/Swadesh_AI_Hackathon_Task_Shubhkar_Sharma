import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../models/booking.dart';
import '../repository/booking_repository.dart';

/// Provider that fetches the current user's bookings.
///
/// Watches the auth provider so it re-fetches when the user changes.
/// Uses FutureProvider for automatic loading/error/data states.
final myBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final user = ref.watch(authProvider);
  if (user == null) return [];

  final repository = ref.read(bookingRepositoryProvider);
  return repository.getUserBookings(user.id);
});
