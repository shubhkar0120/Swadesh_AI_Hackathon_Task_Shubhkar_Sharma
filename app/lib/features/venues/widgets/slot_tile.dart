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
import '../../../shared/widgets/motion_widgets.dart';

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
    if (isBookedByMe) return AppTheme.slotBookedByMe.withValues(alpha: 0.18);
    if (isBooked) return AppTheme.cardColor.withValues(alpha: 0.4);
    return AppTheme.slotAvailable.withValues(alpha: 0.08);
  }

  Color get _borderColor {
    if (isBookedByMe) return AppTheme.slotBookedByMe;
    if (isBooked) return AppTheme.textMuted.withValues(alpha: 0.2);
    return AppTheme.slotAvailable.withValues(alpha: 0.45);
  }

  Color get _textColor {
    if (isBookedByMe) return AppTheme.slotBookedByMe;
    if (isBooked) return AppTheme.textMuted;
    return AppTheme.slotAvailable;
  }

  String get _statusText {
    if (isBookedByMe) return 'Your Slot';
    if (isBooked) return 'Booked';
    return 'Available';
  }

  IconData get _statusIcon {
    if (isBookedByMe) return Icons.bookmark_added_rounded;
    if (isBooked) return Icons.lock_outline_rounded;
    return Icons.add_circle_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _borderColor,
          width: isBookedByMe ? 2.0 : 1.2,
        ),
        boxShadow: isBookedByMe
            ? [
                BoxShadow(
                  color: AppTheme.slotBookedByMe.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_statusIcon, size: 20, color: _textColor),
                const SizedBox(height: 8),
                Text(
                  AppDateUtils.formatTime(startTime),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _textColor,
                        fontSize: 14,
                      ),
                ),
                Text(
                  'to ${AppDateUtils.formatTime(endTime)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _textColor.withValues(alpha: 0.7),
                        fontSize: 10,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  _statusText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: _textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 9.5,
                        letterSpacing: 0.3,
                      ),
                ),
              ],
            ),
    );

    if (isBooked && !isBookedByMe) {
      return tile; // No tap or scale feedback for already booked slots
    }

    return ScaleOnTouch(
      onTap: onTap,
      child: tile,
    );
  }
}
