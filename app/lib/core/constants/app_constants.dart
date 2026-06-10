/// App-wide constants for QuickSlot.
class AppConstants {
  AppConstants._();

  /// Base URL for the backend API.
  /// Change this to your machine's local IP for physical device testing.
  /// e.g., 'http://192.168.1.5:3000'
  static const String baseUrl = 'http://192.168.1.7:3000';

  /// API request timeout in milliseconds.
  static const int connectTimeout = 5000;
  static const int receiveTimeout = 10000;

  /// Polling interval for slot status updates (in seconds).
  static const int slotPollIntervalSeconds = 10;

  /// App name
  static const String appName = 'QuickSlot';
}
