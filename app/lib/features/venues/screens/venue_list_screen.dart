import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';

/// Venue list screen — shows all available sports venues.
///
/// Uses AsyncValue.when() to handle loading, error, and data states.
/// Pull-to-refresh is supported via RefreshIndicator.
import '../../../shared/widgets/motion_widgets.dart';

/// Venue list screen — shows all available sports venues.
///
/// Uses AsyncValue.when() to handle loading, error, and data states.
/// Pull-to-refresh is supported via RefreshIndicator.
class VenueListScreen extends ConsumerWidget {
  const VenueListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venuesAsync = ref.watch(venuesProvider);
    final currentUser = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppTheme.primaryColor, AppTheme.primaryLight],
              ).createShader(bounds),
              child: const Text(
                'QuickSlot',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sports_tennis_rounded,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
        ),
        actions: [
          // My Bookings button
          IconButton(
            onPressed: () => context.push('/my-bookings'),
            icon: const Icon(Icons.bookmark_rounded),
            tooltip: 'My Bookings',
          ),
          // User indicator
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: const Icon(Icons.person, size: 16, color: AppTheme.primaryColor),
              label: Text(
                currentUser?.name ?? 'Guest',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              backgroundColor: AppTheme.surfaceLight.withValues(alpha: 0.8),
              side: BorderSide(color: AppTheme.textMuted.withValues(alpha: 0.15)),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: BackgroundGlow(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(venuesProvider);
          },
          color: AppTheme.primaryColor,
          child: venuesAsync.when(
            loading: () => const AppLoadingWidget(message: 'Loading venues...'),
            error: (error, stack) => AppErrorWidget(
              message: error.toString(),
              onRetry: () => ref.invalidate(venuesProvider),
            ),
            data: (venues) {
              if (venues.isEmpty) {
                return const EmptyStateWidget(
                  icon: Icons.sports_rounded,
                  title: 'No venues available',
                  subtitle: 'Check back later for new venues',
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: venues.length + 1, // +1 for header
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EntranceAnimation(
                        delay: Duration.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find your court',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${venues.length} venues available',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final venue = venues[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EntranceAnimation(
                      delay: Duration(milliseconds: 100 + index * 80),
                      child: ScaleOnTouch(
                        onTap: () {
                          context.push(
                            '/venues/${venue.id}?name=${Uri.encodeComponent(venue.name)}&sport=${Uri.encodeComponent(venue.sportType)}',
                          );
                        },
                        child: VenueCard(
                          name: venue.name,
                          sportType: venue.sportType,
                          location: venue.location,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
