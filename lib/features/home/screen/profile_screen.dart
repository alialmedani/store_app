import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/screen/login_screen_shadcn.dart';

/// Profile Screen - User Profile
class ProfileScreen extends fw.StatelessWidget {
  const ProfileScreen({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentUser;

    return AppSliverScreen(
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: fw.Container(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.screenPaddingHorizontal + 8,
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.sectionGap + 12,
            ),
            decoration: fw.BoxDecoration(
              gradient: fw.LinearGradient(
                begin: fw.Alignment.topLeft,
                end: fw.Alignment.bottomRight,
                colors: [
                  theme.colorScheme.background,
                  theme.colorScheme.background.withValues(alpha: 0.95),
                ],
              ),
              border: fw.Border(
                bottom: fw.BorderSide(
                  color: theme.colorScheme.border.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
            child: fw.Column(
              children: [
                fw.Row(
                  mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    fw.Text(
                      'prfile'.tr(),
                      style: const fw.TextStyle(
                        fontSize: 28,
                        fontWeight: AppDesignTokens.extraBold,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    fw.Container(
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.muted.withValues(alpha: 0.25),
                        borderRadius: fw.BorderRadius.circular(
                          AppDesignTokens.inputRadius,
                        ),
                        border: fw.Border.all(
                          color: theme.colorScheme.border.withValues(
                            alpha: 0.1,
                          ),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const fw.Icon(Icons.logout, size: 20),
                        onPressed: () => _handleLogout(context, authCubit),
                        variance: ButtonVariance.ghost,
                      ),
                    ),
                  ],
                ),
                const fw.SizedBox(height: AppDesignTokens.sectionGap + 8),
                // Profile Avatar
                fw.Container(
                  width: 100,
                  height: 100,
                  decoration: fw.BoxDecoration(
                    gradient: fw.LinearGradient(
                      begin: fw.Alignment.topLeft,
                      end: fw.Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primary.withValues(alpha: 0.2),
                        theme.colorScheme.primary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: fw.BorderRadius.circular(50),
                    border: fw.Border.all(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      width: 3,
                    ),
                  ),
                  child: fw.Center(
                    child: fw.Text(
                      (currentUser?.userName ?? 'U')
                          .substring(0, 1)
                          .toUpperCase(),
                      style: fw.TextStyle(
                        fontSize: 40,
                        fontWeight: AppDesignTokens.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const fw.SizedBox(height: AppDesignTokens.sectionGap),
                fw.Text(
                  currentUser?.userName ?? 'User',
                  style: const fw.TextStyle(
                    fontSize: 24,
                    fontWeight: AppDesignTokens.bold,
                  ),
                ),
                const fw.SizedBox(height: AppDesignTokens.smallGap),
                fw.Text(
                  currentUser?.email ?? '',
                  style: fw.TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Profile Menu Items
        SliverPadding(
          padding: const fw.EdgeInsets.symmetric(
            horizontal: AppDesignTokens.screenPaddingHorizontal,
            vertical: AppDesignTokens.sectionGap,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'edit_profile'.tr(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text(
                        'Edit profile feature will be available soon.',
                      ),
                      actions: [
                        PrimaryButton(
                          onPressed: () => fw.Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
              _ProfileMenuItem(
                icon: Icons.lock_outline,
                title: 'change_password'.tr(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text(
                        'Change password feature will be available soon.',
                      ),
                      actions: [
                        PrimaryButton(
                          onPressed: () => fw.Navigator.pop(ctx),
                          child: Text('ok'.tr()),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
              _ProfileMenuItem(
                icon: Icons.notifications_none,
                title: 'notifications'.tr(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('coming_soon'.tr()),
                      content: const Text(
                        'Notifications settings will be available soon.',
                      ),
                      actions: [
                        PrimaryButton(
                          onPressed: () => fw.Navigator.pop(ctx),
                          child: Text('ok'.tr()),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
              _ProfileMenuItem(
                icon: Icons.settings_outlined,
                title: 'settings'.tr(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('coimng_soon'.tr()),
                      content: const Text('Settings will be available soon.'),
                      actions: [
                        PrimaryButton(
                          onPressed: () => fw.Navigator.pop(ctx),
                          child: Text('ok'.tr()),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
              _ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'Help & Support',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text(
                        'Help & support will be available soon.',
                      ),
                      actions: [
                        PrimaryButton(
                          onPressed: () => fw.Navigator.pop(ctx),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const fw.SizedBox(height: AppDesignTokens.sectionGap),
              _ProfileMenuItem(
                icon: Icons.logout,
                title: 'Logout',
                color: AppDesignTokens.dangerColor,
                onTap: () => _handleLogout(context, authCubit),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogout(
    fw.BuildContext context,
    AuthCubit authCubit,
  ) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          SecondaryButton(
            onPressed: () => fw.Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          DestructiveButton(
            onPressed: () => fw.Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      await authCubit.logout();

      if (context.mounted) {
        fw.Navigator.pushAndRemoveUntil(
          context,
          fw.PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginScreenShadcn(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
          (route) => false,
        );
      }
    }
  }
}

/// Profile Menu Item Widget
class _ProfileMenuItem extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final fw.Color? color;
  final fw.VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final itemColor = color ?? theme.colorScheme.foreground;

    return fw.GestureDetector(
      onTap: onTap,
      child: Card(
        child: fw.Padding(
          padding: const fw.EdgeInsets.all(16),
          child: fw.Row(
            children: [
              fw.Container(
                padding: const fw.EdgeInsets.all(10),
                decoration: fw.BoxDecoration(
                  color: itemColor.withValues(alpha: 0.1),
                  borderRadius: fw.BorderRadius.circular(10),
                ),
                child: fw.Icon(icon, size: 20, color: itemColor),
              ),
              const fw.SizedBox(width: AppDesignTokens.itemGap),
              fw.Expanded(
                child: fw.Text(
                  title,
                  style: fw.TextStyle(
                    fontSize: 16,
                    fontWeight: fw.FontWeight.w600,
                    color: itemColor,
                  ),
                ),
              ),
              fw.Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
