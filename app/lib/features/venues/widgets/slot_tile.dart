import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';

/// A tile widget representing a single time slot.
///
/// Color coding:
/// - Green: Available
/// - Teal/lighter: Booked by current user
/// - Red: Booked by someone else
///
/// Tapping an available slot triggers the booking flow.
class SlotTile extends StatelessWidget {
  final String startTime;
  final String endTime;
  final bool isBooked;
  final bool isBookedByMe;
  final bool isLoading;
  final VoidCallback? onTap;

  const SlotTile({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
    this.isBookedByMe = false,
    this.isLoading = false,
    this.onTap,
  });

  Color get _backgroundColor {
    if (isBookedByMe) return AppTheme.slotBookedByMe.withValues(alpha: 0.2);
    if (isBooked) return AppTheme.slotBooked.withValues(alpha: 0.15);
    return AppTheme.slotAvailable.withValues(alpha: 0.15);
  }

  Color get _borderColor {
    if (isBookedByMe) return AppTheme.slotBookedByMe;
    if (isBooked) return AppTheme.slotBooked.withValues(alpha: 0.4);
    return AppTheme.slotAvailable.withValues(alpha: 0.5);
  }

  Color get _textColor {
    if (isBookedByMe) return AppTheme.slotBookedByMe;
    if (isBooked) return AppTheme.slotBooked;
    return AppTheme.slotAvailable;
  }

  String get _statusText {
    if (isBookedByMe) return 'Your Booking';
    if (isBooked) return 'Booked';
    return 'Available';
  }

  IconData get _statusIcon {
    if (isBookedByMe) return Icons.check_circle_rounded;
    if (isBooked) return Icons.block_rounded;
    return Icons.access_time_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isBooked && !isBookedByMe ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _borderColor, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(_statusIcon, size: 18, color: _textColor),
                    const SizedBox(height: 4),
                    Text(
                      AppDateUtils.formatTime(startTime),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: _textColor,
                          ),
                    ),
                    Text(
                      AppDateUtils.formatTime(endTime),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _textColor.withValues(alpha: 0.7),
                            fontSize: 11,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _statusText,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: _textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
