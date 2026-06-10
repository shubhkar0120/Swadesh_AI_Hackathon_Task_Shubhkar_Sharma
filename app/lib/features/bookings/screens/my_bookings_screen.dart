import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/booking.dart';
import '../providers/booking_provider.dart';
import '../repository/booking_repository.dart';
import '../widgets/booking_card.dart';
import '../../venues/providers/venue_provider.dart';

import '../../../shared/widgets/motion_widgets.dart';

/// My Bookings screen — shows all bookings for the current user.
///
/// Features:
/// - Pull-to-refresh
/// - Cancel booking with confirmation
/// - Loading/error/empty states
class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  String? _cancellingBookingId;

  Future<void> _cancelBooking(Booking booking) async {
    final user = ref.read(authProvider);
    if (user == null) return;

    // Confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cancel Booking?'),
        content: const Text(
          'Are you sure you want to cancel this booking? The slot will become available for others.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    final bookingId = booking.id;
    setState(() => _cancellingBookingId = bookingId);

    try {
      final repo = ref.read(bookingRepositoryProvider);
      await repo.cancelBooking(bookingId: bookingId, userId: user.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_rounded, color: AppTheme.successColor),
              SizedBox(width: 8),
              Text('Booking cancelled successfully'),
            ],
          ),
          backgroundColor: AppTheme.surfaceLight,
        ),
      );

      // Refresh bookings
      ref.invalidate(myBookingsProvider);

      // Refresh slots grid instantly for this specific venue + date
      if (booking.venue != null && booking.slot != null) {
        final slotKey = '${booking.venue!.id}|${booking.slot!.date}';
        ref.invalidate(slotsProvider(slotKey));
      }
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _cancellingBookingId = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(myBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: BackgroundGlow(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(myBookingsProvider);
          },
          color: AppTheme.primaryColor,
          child: bookingsAsync.when(
            loading: () =>
                const AppLoadingWidget(message: 'Loading your bookings...'),
            error: (error, stack) => AppErrorWidget(
              message: error.toString(),
              onRetry: () => ref.invalidate(myBookingsProvider),
            ),
            data: (bookings) {
              if (bookings.isEmpty) {
                return ListView(
                  children: const [
                    SizedBox(height: 100),
                    EmptyStateWidget(
                      icon: Icons.bookmark_border_rounded,
                      title: 'No bookings yet',
                      subtitle:
                          'Book a slot from a venue to see it here',
                    ),
                  ],
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EntranceAnimation(
                        delay: Duration.zero,
                        child: Text(
                          '${bookings.length} booking${bookings.length == 1 ? '' : 's'}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                        ),
                      ),
                    );
                  }

                  final booking = bookings[index - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: EntranceAnimation(
                      delay: Duration(milliseconds: 100 + index * 80),
                      child: BookingCard(
                        booking: booking,
                        isCancelling: _cancellingBookingId == booking.id,
                        onCancel: () => _cancelBooking(booking),
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
