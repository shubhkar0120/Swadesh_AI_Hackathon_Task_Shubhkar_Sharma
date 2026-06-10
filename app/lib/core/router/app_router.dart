import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/user_select_screen.dart';
import '../../features/venues/screens/venue_list_screen.dart';
import '../../features/venues/screens/venue_detail_screen.dart';
import '../../features/bookings/screens/my_bookings_screen.dart';

/// App router configuration using GoRouter.
///
/// Route tree:
///   /                → User select screen
///   /venues          → Venue list (requires user to be selected)
///   /venues/:id      → Venue detail with slot grid
///   /my-bookings     → User's bookings with cancel option
Page<void> _buildTransitionPage({
  required Widget child,
  required GoRouterState state,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.05, 0.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      );
    },
  );
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'user-select',
      pageBuilder: (context, state) => _buildTransitionPage(
        child: const UserSelectScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/venues',
      name: 'venues',
      pageBuilder: (context, state) => _buildTransitionPage(
        child: const VenueListScreen(),
        state: state,
      ),
    ),
    GoRoute(
      path: '/venues/:id',
      name: 'venue-detail',
      pageBuilder: (context, state) {
        final venueId = state.pathParameters['id']!;
        final venueName = state.uri.queryParameters['name'] ?? 'Venue';
        final sportType = state.uri.queryParameters['sport'] ?? '';
        return _buildTransitionPage(
          child: VenueDetailScreen(
            venueId: venueId,
            venueName: venueName,
            sportType: sportType,
          ),
          state: state,
        );
      },
    ),
    GoRoute(
      path: '/my-bookings',
      name: 'my-bookings',
      pageBuilder: (context, state) => _buildTransitionPage(
        child: const MyBookingsScreen(),
        state: state,
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
