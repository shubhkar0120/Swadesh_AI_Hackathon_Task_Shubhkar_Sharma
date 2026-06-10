import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/booking.dart';

/// Repository for booking-related API calls.
///
/// Handles:
/// - POST /bookings — book a slot (concurrency-safe)
/// - DELETE /bookings/:id — cancel a booking
/// - GET /users/:id/bookings — get user's bookings
///
/// The X-User-Id header is set per-request, not globally,
/// because different users can be tested on the same device.
class BookingRepository {
  final Dio _dio;

  BookingRepository(this._dio);

  /// Books a slot for a user.
  ///
  /// Returns the created Booking on success (201).
  /// Throws SlotAlreadyBookedException on 409 (double-booking).
  /// Throws other exceptions for other errors.
  Future<Booking> bookSlot({
    required String slotId,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.bookings,
        data: {'slotId': slotId},
        options: Options(headers: {'X-User-Id': userId}),
      );
      return Booking.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Cancels a booking.
  Future<void> cancelBooking({
    required String bookingId,
    required String userId,
  }) async {
    try {
      await _dio.delete(
        ApiEndpoints.cancelBooking(bookingId),
        options: Options(headers: {'X-User-Id': userId}),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Gets all bookings for a user (with venue + slot details).
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.userBookings(userId),
        options: Options(headers: {'X-User-Id': userId}),
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Booking.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Maps Dio errors to typed app exceptions.
  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NetworkException();
    }

    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ?? 'Something went wrong';

    switch (statusCode) {
      case 409:
        return const SlotAlreadyBookedException();
      case 403:
        return ForbiddenException(message);
      case 404:
        return NotFoundException(message);
      case 400:
        return ServerException(message, statusCode: 400);
      default:
        return ServerException(message, statusCode: statusCode);
    }
  }
}

/// Provider for BookingRepository.
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepository(ref.read(dioProvider));
});
