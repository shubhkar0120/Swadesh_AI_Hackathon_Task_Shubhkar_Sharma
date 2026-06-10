import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../models/venue.dart';
import '../models/slot.dart';

/// Repository for venue-related API calls.
///
/// Handles:
/// - GET /venues — fetch all venues
/// - GET /venues/:id/slots?date= — fetch slots for a venue on a date
///
/// Defense answer: "Repository abstracts the data source.
/// Today it calls an API. Tomorrow it could read from a local cache.
/// The UI doesn't know or care where data comes from."
class VenueRepository {
  final Dio _dio;

  VenueRepository(this._dio);

  /// Fetches all venues from the backend.
  Future<List<Venue>> getVenues() async {
    try {
      final response = await _dio.get(ApiEndpoints.venues);
      final List<dynamic> data = response.data;
      return data.map((json) => Venue.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Fetches slots for a venue on a specific date.
  Future<List<Slot>> getSlots(String venueId, String date) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.venueSlots(venueId),
        queryParameters: {'date': date},
      );
      final List<dynamic> data = response.data;
      return data.map((json) => Slot.fromJson(json)).toList();
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
      case 404:
        return NotFoundException(message);
      case 400:
        return ServerException(message, statusCode: 400);
      default:
        return ServerException(message, statusCode: statusCode);
    }
  }
}

/// Provider for VenueRepository.
final venueRepositoryProvider = Provider<VenueRepository>((ref) {
  return VenueRepository(ref.read(dioProvider));
});
