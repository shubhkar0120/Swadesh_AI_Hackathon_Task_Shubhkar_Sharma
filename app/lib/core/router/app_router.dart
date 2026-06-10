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
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'user-select',
      builder: (context, state) => const UserSelectScreen(),
    ),
    GoRoute(
      path: '/venues',
      name: 'venues',
      builder: (context, state) => const VenueListScreen(),
    ),
    GoRoute(
      path: '/venues/:id',
      name: 'venue-detail',
      builder: (context, state) {
        final venueId = state.pathParameters['id']!;
        final venueName = state.uri.queryParameters['name'] ?? 'Venue';
        final sportType = state.uri.queryParameters['sport'] ?? '';
        return VenueDetailScreen(
          venueId: venueId,
          venueName: venueName,
          sportType: sportType,
        );
      },
    ),
    GoRoute(
      path: '/my-bookings',
      name: 'my-bookings',
      builder: (context, state) => const MyBookingsScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
