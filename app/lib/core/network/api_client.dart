import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';

/// Provides a configured Dio instance for API calls.
///
/// Includes:
/// - Base URL from AppConstants
/// - Timeouts
/// - X-User-Id header interceptor (set dynamically based on logged-in user)
/// - Request/Response logging
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(milliseconds: AppConstants.connectTimeout),
    receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeout),
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Logging interceptor — useful during development/demo
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    logPrint: (obj) => debugPrint('[DIO] $obj'),
  ));

  return dio;
});
