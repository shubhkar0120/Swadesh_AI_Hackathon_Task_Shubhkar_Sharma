// Custom exception types for the app.
//
// These provide structured error handling that maps to
// specific UI states (error messages, retry options).

class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error. Please check your connection.']);
}

/// Server returned an error
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

/// Slot already booked by someone else (409 Conflict)
class SlotAlreadyBookedException extends AppException {
  const SlotAlreadyBookedException()
      : super('This slot has already been booked by someone else.');
}

/// Unauthorized / forbidden action
class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'You are not authorized to perform this action.']);
}

/// Resource not found
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found.']);
}
