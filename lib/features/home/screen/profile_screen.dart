import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../trash/screen/trash_screen.dart';
import '../../auth/screen/login_screen_shadcn.dart';
import '../../../core/ui/shadcn/design_system/theme_controller.dart';

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
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.95),
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
                  currentUser?.userName ?? 'user'.tr(),
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
              _SettingCard(
                icon: Icons.palette_outlined,
                title: 'appearance'.tr(),
                child: fw.ListenableBuilder(
                  listenable: ThemeController.instance,
                  builder: (ctx, _) => _SegmentedPicker<AppThemeMode>(
                    selected: ThemeController.instance.mode,
                    onChanged: ThemeController.instance.setMode,
                    items: [
                      (AppThemeMode.light, 'theme_light'.tr()),
                      (AppThemeMode.dark, 'theme_dark'.tr()),
                      (AppThemeMode.system, 'theme_system'.tr()),
                    ],
                  ),
                ),
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
              _SettingCard(
                icon: Icons.language,
                title: 'language'.tr(),
                child: _SegmentedPicker<String>(
                  selected: context.locale.languageCode,
                  onChanged: (code) => context.setLocale(Locale(code)),
                  items: const [('ar', 'العربية'), ('en', 'English')],
                ),
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
              _ProfileMenuItem(
                icon: Icons.restore_from_trash_outlined,
                title: 'deleted_items'.tr(),
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const TrashScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              const fw.SizedBox(height: AppDesignTokens.itemGap),
              _ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'edit_profile'.tr(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('coming_soon'.tr()),
                      content: Text(
                        'edit_profile_feature_will_be_available'.tr(),
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
                icon: Icons.lock_outline,
                title: 'change_password'.tr(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('coming_soon'.tr()),
                      content: Text(
                        'change_password_feature_will_be_availa'.tr(),
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
                      content: Text(
                        'notifications_settings_will_be_availab'.tr(),
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
                icon: Icons.help_outline,
                title: 'help_support'.tr(),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('coming_soon'.tr()),
                      content: Text(
                        'help_support_will_be_available_soon'.tr(),
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
              const fw.SizedBox(height: AppDesignTokens.sectionGap),
              _ProfileMenuItem(
                icon: Icons.logout,
                title: 'logout'.tr(),
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
        title: Text('logout'.tr()),
        content: Text('are_you_sure_you_want_to_logout'.tr()),
        actions: [
          SecondaryButton(
            onPressed: () => fw.Navigator.pop(ctx, false),
            child: Text('cancel'.tr()),
          ),
          DestructiveButton(
            onPressed: () => fw.Navigator.pop(ctx, true),
            child: Text('logout'.tr()),
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

/// Card with a title row and an inline control (theme / language picker).
class _SettingCard extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final fw.Widget child;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return AppCard(
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          fw.Row(
            children: [
              fw.Icon(icon, size: 20, color: AppDesignTokens.mutedTextColor),
              const fw.SizedBox(width: AppDesignTokens.itemGap - 2),
              fw.Text(
                title,
                style: const fw.TextStyle(
                  fontSize: AppDesignTokens.bodyFontSize + 1,
                  fontWeight: AppDesignTokens.semiBold,
                ),
              ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),
          child,
        ],
      ),
    );
  }
}

/// Pill segmented control: the selected segment is a raised card.
class _SegmentedPicker<T> extends fw.StatelessWidget {
  final List<(T, String)> items;
  final T selected;
  final fw.ValueChanged<T> onChanged;

  const _SegmentedPicker({
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: const fw.EdgeInsets.all(4),
      decoration: fw.BoxDecoration(
        color: AppDesignTokens.mutedSurfaceColor,
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.pillRadius),
      ),
      child: fw.Row(
        children: [
          for (final item in items)
            fw.Expanded(
              child: fw.GestureDetector(
                behavior: fw.HitTestBehavior.opaque,
                onTap: () => onChanged(item.$1),
                child: fw.AnimatedContainer(
                  duration: AppDesignTokens.motionFast,
                  height: 38,
                  alignment: fw.Alignment.center,
                  decoration: fw.BoxDecoration(
                    color: item.$1 == selected
                        ? AppDesignTokens.cardColor
                        : const fw.Color(0x00000000),
                    borderRadius: fw.BorderRadius.circular(
                      AppDesignTokens.pillRadius,
                    ),
                    boxShadow: item.$1 == selected
                        ? AppDesignTokens.cardShadow(
                            AppDesignTokens.titleTextColor,
                          )
                        : null,
                  ),
                  child: fw.Text(
                    item.$2,
                    style: fw.TextStyle(
                      fontSize: AppDesignTokens.captionFontSize + 1,
                      fontWeight: AppDesignTokens.semiBold,
                      color: item.$1 == selected
                          ? AppDesignTokens.titleTextColor
                          : AppDesignTokens.mutedTextColor,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
