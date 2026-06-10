import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

/// Holds the currently selected user.
///
/// This is a simple StateNotifier — no API call needed.
/// Users are hardcoded in the backend and fetched once,
/// then the user selects one from the list.
///
/// The selected user's ID is sent as X-User-Id header with every API request.
class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  void selectUser(User user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}

/// Provider for the auth state (selected user).
final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

/// Convenience provider to get the current user's ID.
/// Throws if no user is selected.
final currentUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) throw Exception('No user selected');
  return user.id;
});
