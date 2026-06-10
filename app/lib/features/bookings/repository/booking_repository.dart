import 'dart:convert';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/booking.dart';

/// Repository for booking-related API calls with local offline cache.
///
/// Handles:
/// - POST /bookings — book a slot (concurrency-safe)
/// - DELETE /bookings/:id — cancel a booking (updates cache)
/// - GET /users/:id/bookings — get user's bookings (reads/writes offline cache)
class BookingRepository {
  final Dio _dio;

  BookingRepository(this._dio);

  /// Books a slot for a user.
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
      // Remove from offline cache
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('bookings_cache_$userId');
        if (cachedData != null) {
          final List<dynamic> decoded = jsonDecode(cachedData);
          final updated = decoded.where((item) => item['id'] != bookingId).toList();
          await prefs.setString('bookings_cache_$userId', jsonEncode(updated));
        }
      } catch (cacheError) {
        // Silently ignore cache write errors
        dev.log('[CACHE] Failed to update cache', error: cacheError);
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Gets all bookings for a user (with venue + slot details) with offline caching.
  Future<List<Booking>> getUserBookings(String userId) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.userBookings(userId),
        options: Options(headers: {'X-User-Id': userId}),
      );
      final List<dynamic> data = response.data;
      final bookings = data.map((json) => Booking.fromJson(json)).toList();

      // Save to offline cache
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('bookings_cache_$userId', jsonEncode(data));
      } catch (cacheError) {
        dev.log('[CACHE] Failed to write cache', error: cacheError);
      }

      return bookings;
    } on DioException catch (e) {
      // Try loading from offline cache
      try {
        final prefs = await SharedPreferences.getInstance();
        final cachedData = prefs.getString('bookings_cache_$userId');
        if (cachedData != null) {
          final List<dynamic> decoded = jsonDecode(cachedData);
          dev.log('[CACHE] Loading bookings offline for user $userId');
          return decoded.map((json) => Booking.fromJson(json)).toList();
        }
      } catch (cacheError) {
        dev.log('[CACHE] Failed to read cache', error: cacheError);
      }

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
