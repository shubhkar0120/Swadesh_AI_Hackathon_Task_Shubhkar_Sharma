/// All API endpoint paths as constants.
/// Centralized so if any endpoint changes, we only update one file.
class ApiEndpoints {
  ApiEndpoints._();

  static const String health = '/health';
  static const String venues = '/venues';
  static String venueSlots(String venueId) => '/venues/$venueId/slots';
  static const String bookings = '/bookings';
  static String cancelBooking(String bookingId) => '/bookings/$bookingId';
  static String userBookings(String userId) => '/users/$userId/bookings';
  static const String users = '/users';
}
