import 'package:intl/intl.dart';

/// Date formatting helpers used across the app.
class AppDateUtils {
  AppDateUtils._();

  /// Format: 'June 10, 2026'
  static String formatDisplayDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('MMMM d, y').format(date);
  }

  /// Format: 'Tue, Jun 10'
  static String formatShortDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('EEE, MMM d').format(date);
  }

  /// Format: '6:00 AM'
  static String formatTime(String time24) {
    final parts = time24.split(':');
    final hour = int.parse(parts[0]);
    final minute = parts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$hour12:$minute $period';
  }

  /// Format: '6:00 AM - 7:00 AM'
  static String formatTimeRange(String startTime, String endTime) {
    return '${formatTime(startTime)} - ${formatTime(endTime)}';
  }

  /// Returns 'YYYY-MM-DD' for today
  static String todayString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  /// Returns 'YYYY-MM-DD' for a DateTime
  static String toDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
