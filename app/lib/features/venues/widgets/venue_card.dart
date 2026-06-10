import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// A card widget displaying venue information.
///
/// Shows venue name, sport type, location, and a sport icon.
/// Tapping navigates to the venue detail screen.
class VenueCard extends StatelessWidget {
  final String name;
  final String sportType;
  final String location;

  const VenueCard({
    super.key,
    required this.name,
    required this.sportType,
    required this.location,
  });

  /// Maps sport types to relevant icons.
  IconData get _sportIcon {
    switch (sportType.toLowerCase()) {
      case 'badminton':
        return Icons.sports_tennis_rounded;
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'cricket':
        return Icons.sports_cricket_rounded;
      case 'tennis':
        return Icons.sports_tennis_rounded;
      case 'basketball':
        return Icons.sports_basketball_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  /// Maps sport types to accent colors.
  Color get _sportColor {
    switch (sportType.toLowerCase()) {
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
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.textMuted.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Left sport color accent strip
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              color: _sportColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 16, bottom: 16, right: 16),
            child: Row(
              children: [
                // Sport icon
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: _sportColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(_sportIcon, color: _sportColor, size: 28),
                ),
                const SizedBox(width: 16),
                // Venue info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _sportColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              sportType,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: _sportColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppTheme.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textMuted,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppTheme.textMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
