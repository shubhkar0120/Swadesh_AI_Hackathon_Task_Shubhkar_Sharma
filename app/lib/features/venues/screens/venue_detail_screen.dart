import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../../bookings/repository/booking_repository.dart';
import '../models/slot.dart';
import '../providers/venue_provider.dart';
import '../widgets/slot_tile.dart';
import '../../../shared/widgets/motion_widgets.dart';

/// Venue detail screen — date picker + slot grid + booking flow.
///
/// This is the most complex screen in the app. It:
/// 1. Shows a horizontal date selector (today + next 6 days)
/// 2. Displays a grid of time slots with color-coded status
/// 3. Handles booking with confirmation dialog
/// 4. Shows conflict messages gracefully (409 from backend)
/// 5. Auto-refreshes via polling every 10 seconds (bonus feature)
class VenueDetailScreen extends ConsumerStatefulWidget {
  final String venueId;
  final String venueName;
  final String sportType;

  const VenueDetailScreen({
    super.key,
    required this.venueId,
    required this.venueName,
    required this.sportType,
  });

  @override
  ConsumerState<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends ConsumerState<VenueDetailScreen> {
  late String _selectedDate;
  String? _bookingSlotId; // Slot currently being booked (for loading state)
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _selectedDate = AppDateUtils.todayString();
    _startPolling();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  /// Starts polling for slot updates every N seconds.
  /// This is the bonus feature: slot status updates without restarting.
  void _startPolling() {
    _pollTimer = Timer.periodic(
      const Duration(seconds: AppConstants.slotPollIntervalSeconds),
      (_) {
        if (mounted) {
          ref.invalidate(slotsProvider('${widget.venueId}|$_selectedDate'));
        }
      },
    );
  }

  /// The slot key for the current venue+date combination.
  String get _slotKey => '${widget.venueId}|$_selectedDate';

  /// Handles booking a slot.
  Future<void> _bookSlot(Slot slot) async {
    final user = ref.read(authProvider);
    if (user == null) return;

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.venueName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppDateUtils.formatDisplayDate(slot.date),
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              AppDateUtils.formatTimeRange(slot.startTime, slot.endTime),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Book Now'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    // Set loading state for this specific slot
    setState(() => _bookingSlotId = slot.id);

    try {
      final repo = ref.read(bookingRepositoryProvider);
      await repo.bookSlot(slotId: slot.id, userId: user.id);

      if (!mounted) return;

      // Success — show snackbar and refresh slots
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppTheme.successColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Booked ${AppDateUtils.formatTimeRange(slot.startTime, slot.endTime)}!',
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.surfaceLight,
        ),
      );

      // Refresh the slot grid
      ref.invalidate(slotsProvider(_slotKey));
    } on SlotAlreadyBookedException {
      if (!mounted) return;

      // 409 Conflict — slot was taken by someone else
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning_rounded, color: AppTheme.warningColor),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This slot was just booked by someone else! Refreshing...',
                ),
              ),
            ],
          ),
          backgroundColor: AppTheme.surfaceLight,
          duration: Duration(seconds: 3),
        ),
      );

      // Refresh to show updated status
      ref.invalidate(slotsProvider(_slotKey));
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
        setState(() => _bookingSlotId = null);
      }
    }
  }

  Color get _sportColor {
    switch (widget.sportType.toLowerCase()) {
      case 'badminton':
        return AppTheme.primaryColor;
      case 'football':
        return const Color(0xFF4CAF50);
      case 'cricket':
        return const Color(0xFFFF9800);
      case 'tennis':
        return const Color(0xFF2196F3);
      case 'basketball':
        return const Color(0xFFFF5722);
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final slotsAsync = ref.watch(slotsProvider(_slotKey));
    final currentUser = ref.watch(authProvider);

    // Generate date options: today + next 6 days
    final dates = List.generate(7, (i) {
      final d = DateTime.now().add(Duration(days: i));
      return AppDateUtils.toDateString(d);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.venueName),
      ),
      body: BackgroundGlow(
        customColors: [
          _sportColor.withValues(alpha: 0.08),
          AppTheme.surfaceLight.withValues(alpha: 0.1),
        ],
        child: Column(
          children: [
            // Sport type badge + refresh indicator
            EntranceAnimation(
              delay: Duration.zero,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _sportColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.sportType,
                        style: TextStyle(
                          color: _sportColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.refresh_rounded,
                      size: 14,
                      color: AppTheme.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Refreshes every ${AppConstants.slotPollIntervalSeconds}s',
                      style: const TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date selector (horizontal scrolling)
            EntranceAnimation(
              delay: const Duration(milliseconds: 80),
              child: SizedBox(
                height: 76,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    final date = dates[index];
                    final isSelected = date == _selectedDate;
                    final dt = DateTime.parse(date);

                    return ScaleOnTouch(
                      scaleFactor: 0.92,
                      onTap: () {
                        setState(() => _selectedDate = date);
                      },
                      child: Container(
                        width: 58,
                        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  colors: [_sportColor, _sportColor.withValues(alpha: 0.85)],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: isSelected ? null : AppTheme.cardColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? _sportColor.withValues(alpha: 0.5)
                                : AppTheme.textMuted.withValues(alpha: 0.12),
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: _sportColor.withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _dayName(dt),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dt.day}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (isSelected)
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                              )
                            else
                              Text(
                                _monthName(dt),
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Slot legend
            EntranceAnimation(
              delay: const Duration(milliseconds: 140),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _legendDot(AppTheme.slotAvailable.withValues(alpha: 0.6), 'Available'),
                    const SizedBox(width: 16),
                    _legendDot(AppTheme.textMuted.withValues(alpha: 0.4), 'Booked'),
                    const SizedBox(width: 16),
                    _legendDot(AppTheme.slotBookedByMe, 'Yours'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Slot grid
            Expanded(
              child: slotsAsync.when(
                loading: () =>
                    const AppLoadingWidget(message: 'Loading slots...'),
                error: (error, stack) => AppErrorWidget(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(slotsProvider(_slotKey)),
                ),
                data: (slots) {
                  if (slots.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.event_busy_rounded,
                      title: 'No slots available',
                      subtitle: 'Try a different date',
                    );
                  }

                  return EntranceAnimation(
                    delay: const Duration(milliseconds: 200),
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: slots.length,
                      itemBuilder: (context, index) {
                        final slot = slots[index];
                        final isBookedByMe =
                            slot.isBooked &&
                            slot.bookedByUserId == currentUser?.id;

                        return SlotTile(
                          startTime: slot.startTime,
                          endTime: slot.endTime,
                          isBooked: slot.isBooked,
                          isBookedByMe: isBookedByMe,
                          isLoading: _bookingSlotId == slot.id,
                          onTap: slot.isBooked ? null : () => _bookSlot(slot),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  String _dayName(DateTime dt) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }

  String _monthName(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[dt.month - 1];
  }
}
