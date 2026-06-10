import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';

import '../../../shared/widgets/motion_widgets.dart';

/// User selection screen — the entry point of the app.
///
/// Shows 3 hardcoded users. Tapping one sets the auth state
/// and navigates to the venue list.
///
/// This is intentionally simple — the problem statement says
/// "keep auth light" and "hardcoded users + X-User-Id header is acceptable."
class UserSelectScreen extends ConsumerWidget {
  const UserSelectScreen({super.key});

  // Hardcoded users matching the backend seed data
  static const List<User> _users = [
    User(id: 'user-1', name: 'Shubhkar'),
    User(id: 'user-2', name: 'Judge A'),
    User(id: 'user-3', name: 'Judge B'),
  ];

  // User avatars (icons representing each user)
  static const List<IconData> _avatarIcons = [
    Icons.person_rounded,
    Icons.gavel_rounded,
    Icons.gavel_rounded,
  ];

  static const List<Color> _avatarColors = [
    AppTheme.primaryColor,
    Color(0xFF5C6BC0),
    Color(0xFFFF7043),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: BackgroundGlow(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 60),
                // App logo / title
                EntranceAnimation(
                  delay: Duration.zero,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.2),
                              blurRadius: 24,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sports_tennis_rounded,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'QuickSlot',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Book sports slots instantly',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                EntranceAnimation(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    'Who\'s playing?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                // User cards
                Expanded(
                  child: ListView.separated(
                    itemCount: _users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return EntranceAnimation(
                        delay: Duration(milliseconds: 150 + index * 100),
                        child: ScaleOnTouch(
                          onTap: () {
                            ref.read(authProvider.notifier).selectUser(user);
                            context.go('/venues');
                          },
                          child: _UserCard(
                            user: user,
                            icon: _avatarIcons[index],
                            color: _avatarColors[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  final IconData icon;
  final Color color;

  const _UserCard({
    required this.user,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.textMuted.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.id,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textMuted,
                      ),
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
    );
  }
}
