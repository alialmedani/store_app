import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../cubit/home_cubit.dart';
import '../data/model/dashboard_summary_model.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/screen/login_screen_shadcn.dart';
import '../../category/cubit/category_cubit.dart';
import '../../category/screen/category_list_screen.dart';
import '../../category/screen/category_stock_summary_screen.dart';
import '../../inventory/cubit/inventory_cubit.dart';
import '../../inventory/screen/inventory_list_screen.dart';
import '../../order/cubit/order_cubit.dart';
import '../../order/screen/order_list_screen.dart';
import '../../product/screen/product_list_screen.dart';
import '../../product_variant/screen/product_variant_list_screen.dart';
import '../../reports/screen/reports_screen.dart';
import 'package:easy_localization/easy_localization.dart';

/// Dashboard Screen - Ink hero + floating KPI cards + grouped menu list.
///
/// Same data sources as before: [HomeCubit.getDashboardSummary] via
/// [GetModel], [AuthCubit.currentUser], and the same 7 destinations.
class DashboardScreen extends fw.StatelessWidget {
  const DashboardScreen({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentUser;
    final userName = currentUser?.userName ?? 'user'.tr();

    return AppSliverScreen(
      slivers: [
        SliverToBoxAdapter(
          child: GetModel<DashboardSummaryModel>(
            useCaseCallBack: () {
              return context.read<HomeCubit>().getDashboardSummary();
            },
            // Bespoke skeleton previewing the ink hero + floating KPI cards +
            // grouped menu rows (not the generic DetailSkeleton fallback).
            loading: const _DashboardSkeleton(),
            modelBuilder: (summary) {
              return fw.Column(
                crossAxisAlignment: fw.CrossAxisAlignment.start,
                children: [
                  _HeroSection(summary: summary, userName: userName),
                  // Floating block overlaps the ink hero's bottom edge.
                  fw.Transform.translate(
                    offset: const fw.Offset(0, -30),
                    child: fw.Padding(
                      padding: const fw.EdgeInsets.fromLTRB(
                        AppDesignTokens.screenPaddingHorizontal,
                        0,
                        AppDesignTokens.screenPaddingHorizontal,
                        AppDesignTokens.sectionGap,
                      ),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          _FloatingKpis(summary: summary),
                          const fw.SizedBox(height: AppDesignTokens.sectionGap),
                          _MenuList(summary: summary),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  // Kept (pre-existing) logout flow; reachable from future entry points.
  // ignore: unused_element
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

/// Loading skeleton mirroring the dashboard's real structure: the ink hero
/// block, the two floating KPI cards overlapping its bottom edge, and the
/// grouped elevated menu rows. Geometry matches [_HeroSection], [_FloatingKpis]
/// and [_MenuRow] so the transition to real content is seamless.
class _DashboardSkeleton extends fw.StatelessWidget {
  const _DashboardSkeleton();

  // Elevated KPI card placeholder (mirrors [_KpiCard]).
  fw.Widget _kpiCard() => AppCard(
    elevated: true,
    child: fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: const [
        AppSkeletonBox(
          width: 44,
          height: 44,
          borderRadius: AppDesignTokens.iconBoxRadius,
        ),
        fw.SizedBox(height: AppDesignTokens.itemGap),
        AppSkeletonBox(width: 60, height: 26),
        fw.SizedBox(height: AppDesignTokens.smallGap),
        AppSkeletonBox(width: 70, height: 12),
      ],
    ),
  );

  // Elevated menu row placeholder (mirrors [_MenuRow]).
  fw.Widget _menuRow() => fw.Padding(
    padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.itemGap),
    child: AppCard(
      elevated: true,
      padding: const fw.EdgeInsets.all(AppDesignTokens.itemGap + 2),
      child: fw.Row(
        children: const [
          AppSkeletonBox(
            width: 44,
            height: 44,
            borderRadius: AppDesignTokens.iconBoxRadius,
          ),
          fw.SizedBox(width: AppDesignTokens.cardGap),
          fw.Expanded(
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              mainAxisSize: fw.MainAxisSize.min,
              children: [
                AppSkeletonBox(width: 120, height: 15),
                fw.SizedBox(height: AppDesignTokens.smallGap),
                AppSkeletonBox(width: 160, height: 12),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  fw.Widget _sectionLabel() => const fw.Padding(
    padding: fw.EdgeInsets.only(
      left: AppDesignTokens.tinyGap,
      bottom: AppDesignTokens.itemGap,
    ),
    child: AppSkeletonBox(width: 90, height: 12),
  );

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        // Ink hero block (same rounded-bottom ink surface as [_HeroSection]).
        fw.Container(
          width: double.infinity,
          padding: const fw.EdgeInsets.fromLTRB(
            AppDesignTokens.screenPaddingHorizontal + 4,
            AppDesignTokens.sectionGap,
            AppDesignTokens.screenPaddingHorizontal + 4,
            AppDesignTokens.sectionGap + 30,
          ),
          decoration: fw.BoxDecoration(
            color: AppDesignTokens.navBackgroundColor,
            borderRadius: const fw.BorderRadius.only(
              bottomLeft: fw.Radius.circular(26),
              bottomRight: fw.Radius.circular(26),
            ),
          ),
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              fw.Row(
                crossAxisAlignment: fw.CrossAxisAlignment.start,
                children: const [
                  fw.Expanded(
                    child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.start,
                      children: [
                        AppSkeletonBox(width: 120, height: 11),
                        fw.SizedBox(height: AppDesignTokens.smallGap),
                        AppSkeletonBox(width: 200, height: 24),
                      ],
                    ),
                  ),
                  fw.SizedBox(width: AppDesignTokens.itemGap),
                  AppSkeletonBox(width: 48, height: 48, borderRadius: 99),
                ],
              ),
              const fw.SizedBox(height: AppDesignTokens.sectionGap + 6),
              fw.Row(
                crossAxisAlignment: fw.CrossAxisAlignment.end,
                children: const [
                  fw.Expanded(
                    child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.start,
                      children: [
                        AppSkeletonBox(width: 110, height: 48),
                        fw.SizedBox(height: AppDesignTokens.smallGap),
                        AppSkeletonBox(width: 90, height: 14),
                      ],
                    ),
                  ),
                  fw.SizedBox(width: AppDesignTokens.itemGap),
                  AppSkeletonBox(width: 84, height: 84, borderRadius: 99),
                ],
              ),
            ],
          ),
        ),
        // Floating block overlaps the ink hero's bottom edge.
        fw.Transform.translate(
          offset: const fw.Offset(0, -30),
          child: fw.Padding(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              0,
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.sectionGap,
            ),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                fw.Row(
                  children: [
                    fw.Expanded(child: _kpiCard()),
                    const fw.SizedBox(width: AppDesignTokens.cardGap),
                    fw.Expanded(child: _kpiCard()),
                  ],
                ),
                const fw.SizedBox(height: AppDesignTokens.sectionGap),
                _sectionLabel(),
                _menuRow(),
                _menuRow(),
                _menuRow(),
                _menuRow(),
                const fw.SizedBox(height: AppDesignTokens.sectionGap),
                _sectionLabel(),
                _menuRow(),
                _menuRow(),
                _menuRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Ink hero: dark ground with a warm radial glow, a greeting + avatar, and a
/// headline metric with a circular stock-health ring.
class _HeroSection extends fw.StatelessWidget {
  final DashboardSummaryModel summary;
  final String userName;

  const _HeroSection({required this.summary, required this.userName});

  @override
  fw.Widget build(fw.BuildContext context) {
    final onInk = AppDesignTokens.onAccentColor;
    final muted = AppDesignTokens.navMutedColor;
    final total = summary.totalProducts ?? 0;

    // Stock health = in-stock variants / total variants (fallback to products).
    final totalVariants = summary.totalVariants ?? 0;
    final instockVariants = summary.instockVariants ?? 0;
    double health;
    if (totalVariants > 0) {
      health = instockVariants / totalVariants;
    } else if ((summary.totalProducts ?? 0) > 0) {
      health = (summary.instockProducts ?? 0) / summary.totalProducts!;
    } else {
      health = 0;
    }
    health = health.clamp(0.0, 1.0);

    final dateLabel =
        '${'today'.tr()} · ${DateFormat.MMMd().format(DateTime.now())}'
            .toUpperCase();

    return fw.Container(
      width: double.infinity,
      padding: const fw.EdgeInsets.fromLTRB(
        AppDesignTokens.screenPaddingHorizontal + 4,
        AppDesignTokens.sectionGap,
        AppDesignTokens.screenPaddingHorizontal + 4,
        // Extra bottom ink so the floating cards can overlap into it.
        AppDesignTokens.sectionGap + 30,
      ),
      decoration: fw.BoxDecoration(
        color: AppDesignTokens.navBackgroundColor,
        borderRadius: const fw.BorderRadius.only(
          bottomLeft: fw.Radius.circular(26),
          bottomRight: fw.Radius.circular(26),
        ),
        // Warm radial glow from the top-right: a low-opacity ember tint over
        // ink (token-derived, no new arbitrary color).
        gradient: fw.RadialGradient(
          center: const fw.Alignment(0.95, -1.0),
          radius: 1.1,
          colors: [
            AppDesignTokens.ember.withValues(alpha: 0.22),
            AppDesignTokens.navBackgroundColor.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.7],
        ),
      ),
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              fw.Expanded(
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    fw.Text(
                      dateLabel,
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.smallCaptionFontSize,
                        fontWeight: AppDesignTokens.semiBold,
                        letterSpacing: 1.4,
                        color: muted,
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.smallGap),
                    fw.Text(
                      '${'welcome_back'.tr()}, $userName',
                      style: fw.TextStyle(
                        fontSize: 24,
                        fontWeight: AppDesignTokens.bold,
                        letterSpacing: AppDesignTokens.titleLetterSpacing,
                        height: 1.1,
                        color: onInk,
                      ),
                    ),
                  ],
                ),
              ),
              const fw.SizedBox(width: AppDesignTokens.itemGap),
              _Avatar(userName: userName),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.sectionGap + 6),
          fw.Row(
            crossAxisAlignment: fw.CrossAxisAlignment.end,
            children: [
              fw.Expanded(
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    CountUpText(
                      value: total,
                      style: fw.TextStyle(
                        fontFamily: AppDesignTokens.displayFontFamily,
                        fontFamilyFallback:
                            AppDesignTokens.displayFontFamilyFallback,
                        fontStyle: fw.FontStyle.italic,
                        fontSize: 52,
                        height: 1.0,
                        letterSpacing: AppDesignTokens.displayLetterSpacing,
                        color: onInk,
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.tinyGap + 2),
                    fw.Text(
                      'total_products'.tr(),
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.bodyFontSize,
                        fontWeight: AppDesignTokens.medium,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
              const fw.SizedBox(width: AppDesignTokens.itemGap),
              _StockHealthRing(percent: health),
            ],
          ),
        ],
      ),
    );
  }
}

/// Circular avatar with the username initial, ember gradient fill.
class _Avatar extends fw.StatelessWidget {
  final String userName;
  const _Avatar({required this.userName});

  @override
  fw.Widget build(fw.BuildContext context) {
    final initial = userName.trim().isNotEmpty
        ? userName.trim().characters.first.toUpperCase()
        : '?';
    return fw.Container(
      width: 48,
      height: 48,
      alignment: fw.Alignment.center,
      decoration: const fw.BoxDecoration(
        shape: fw.BoxShape.circle,
        gradient: AppDesignTokens.primaryGradient,
        boxShadow: AppDesignTokens.glowShadow,
      ),
      child: fw.Text(
        initial,
        style: fw.TextStyle(
          fontSize: 20,
          fontWeight: AppDesignTokens.bold,
          color: AppDesignTokens.onAccentColor,
        ),
      ),
    );
  }
}

/// Circular stock-health ring (ember stroke) with the percentage centered.
class _StockHealthRing extends fw.StatelessWidget {
  final double percent;
  const _StockHealthRing({required this.percent});

  @override
  fw.Widget build(fw.BuildContext context) {
    const size = 84.0;
    return fw.SizedBox(
      width: size,
      height: size,
      child: fw.TweenAnimationBuilder<double>(
        tween: fw.Tween<double>(begin: 0, end: percent),
        duration: const Duration(milliseconds: 1100),
        curve: AppDesignTokens.easeOut,
        builder: (context, value, _) {
          return fw.CustomPaint(
            painter: _RingPainter(
              percent: value,
              track: AppDesignTokens.onAccentColor.withValues(alpha: 0.14),
            ),
            child: fw.Center(
              child: fw.Column(
                mainAxisSize: fw.MainAxisSize.min,
                children: [
                  fw.Text(
                    '${(value * 100).round()}%',
                    style: fw.TextStyle(
                      fontSize: 20,
                      fontWeight: AppDesignTokens.bold,
                      color: AppDesignTokens.onAccentColor,
                      fontFeatures: AppDesignTokens.tabularFigures,
                    ),
                  ),
                  fw.Text(
                    'stock_health'.tr(),
                    textAlign: fw.TextAlign.center,
                    style: fw.TextStyle(
                      fontSize: AppDesignTokens.smallCaptionFontSize - 2,
                      fontWeight: AppDesignTokens.medium,
                      color: AppDesignTokens.navMutedColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends fw.CustomPainter {
  final double percent;
  final fw.Color track;

  _RingPainter({required this.percent, required this.track});

  @override
  void paint(fw.Canvas canvas, fw.Size size) {
    const stroke = 7.0;
    final center = fw.Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final rect = fw.Rect.fromCircle(center: center, radius: radius);

    final trackPaint = fw.Paint()
      ..style = fw.PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = fw.StrokeCap.round
      ..color = track;
    canvas.drawCircle(center, radius, trackPaint);

    if (percent <= 0) return;
    final sweep = 2 * math.pi * percent;
    final progressPaint = fw.Paint()
      ..style = fw.PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = fw.StrokeCap.round
      ..shader = const fw.SweepGradient(
        colors: [AppDesignTokens.ember, AppDesignTokens.emberDeep],
      ).createShader(rect);
    canvas.drawArc(rect, -math.pi / 2, sweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.percent != percent || old.track != track;
}

/// Two elevated KPI cards that float over the ink hero's bottom edge.
class _FloatingKpis extends fw.StatelessWidget {
  final DashboardSummaryModel summary;
  const _FloatingKpis({required this.summary});

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      children: [
        fw.Expanded(
          child: _KpiCard(
            animationIndex: 0,
            icon: Icons.check_circle_rounded,
            value: summary.instockProducts ?? 0,
            label: 'in_stock'.tr(),
            color: AppDesignTokens.successColor,
          ),
        ),
        const fw.SizedBox(width: AppDesignTokens.cardGap),
        fw.Expanded(
          child: _KpiCard(
            animationIndex: 1,
            icon: Icons.warning_rounded,
            value: summary.lowStockProducts ?? 0,
            label: 'low_stock'.tr(),
            color: AppDesignTokens.warningColor,
          ),
        ),
      ],
    );
  }
}

class _KpiCard extends fw.StatelessWidget {
  final fw.IconData icon;
  final int value;
  final String label;
  final fw.Color color;
  final int animationIndex;

  const _KpiCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.animationIndex,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return FadeSlideIn(
      index: animationIndex,
      child: AppCard(
        // Lifted so the card reads as floating over the hero.
        elevated: true,
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            AppIconChip(icon: icon, color: color),
            const fw.SizedBox(height: AppDesignTokens.itemGap),
            CountUpText(
              value: value,
              style: const fw.TextStyle(
                fontSize: 28,
                fontWeight: AppDesignTokens.bold,
                letterSpacing: AppDesignTokens.titleLetterSpacing,
                height: 1,
                fontFeatures: [fw.FontFeature.tabularFigures()],
              ),
            ),
            const fw.SizedBox(height: AppDesignTokens.tinyGap + 2),
            fw.Text(
              label,
              style: fw.TextStyle(
                fontSize: AppDesignTokens.captionFontSize + 1,
                fontWeight: AppDesignTokens.medium,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Grouped menu list (Catalog / Operations) of elevated rows.
class _MenuList extends fw.StatelessWidget {
  final DashboardSummaryModel summary;
  const _MenuList({required this.summary});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final lowStock = summary.lowStockProducts ?? 0;

    return fw.Column(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        _sectionLabel('catalog'.tr()),
        _MenuRow(
          animationIndex: 0,
          icon: Icons.category_rounded,
          title: 'categories'.tr(),
          subtitle: 'manage_categories'.tr(),
          color: theme.colorScheme.primary,
          onTap: () => _push(context, const CategoryListScreen()),
        ),
        _MenuRow(
          animationIndex: 1,
          icon: Icons.inventory_2_rounded,
          title: 'products'.tr(),
          subtitle: 'manage_products'.tr(),
          color: AppDesignTokens.successColor,
          onTap: () => _push(context, const ProductListScreen()),
        ),
        _MenuRow(
          animationIndex: 2,
          icon: Icons.style_rounded,
          title: 'product_variants'.tr(),
          subtitle: 'manage_variants'.tr(),
          color: AppDesignTokens.infoColor,
          onTap: () => _push(context, const ProductVariantListScreen()),
        ),
        _MenuRow(
          animationIndex: 3,
          icon: Icons.warehouse_rounded,
          title: 'inventory'.tr(),
          subtitle: 'stock_movements'.tr(),
          color: AppDesignTokens.blushColor,
          // Real "needs attention" count from the summary model.
          badge: lowStock > 0 ? lowStock : null,
          onTap: () => _push(
            context,
            BlocProvider(
              create: (_) => InventoryCubit(),
              child: const InventoryListScreen(),
            ),
          ),
        ),
        const fw.SizedBox(height: AppDesignTokens.sectionGap),
        _sectionLabel('operations'.tr()),
        _MenuRow(
          animationIndex: 4,
          icon: Icons.shopping_cart_rounded,
          title: 'orders'.tr(),
          subtitle: 'view_orders'.tr(),
          color: AppDesignTokens.accentSecondaryColor,
          onTap: () => _push(
            context,
            BlocProvider(
              create: (_) => OrderCubit(),
              child: const OrderListScreen(),
            ),
          ),
        ),
        _MenuRow(
          animationIndex: 5,
          icon: Icons.assessment_rounded,
          title: 'category_stock'.tr(),
          subtitle: 'stock_by_category'.tr(),
          color: AppDesignTokens.accentSecondaryColor,
          onTap: () => _push(
            context,
            BlocProvider(
              create: (_) => CategoryCubit(),
              child: const CategoryStockSummaryScreen(),
            ),
          ),
        ),
        _MenuRow(
          animationIndex: 6,
          icon: Icons.bar_chart_rounded,
          title: 'reports'.tr(),
          subtitle: 'view_analytics'.tr(),
          color: AppDesignTokens.warningColor,
          onTap: () => _push(context, const ReportsScreen()),
        ),
      ],
    );
  }

  fw.Widget _sectionLabel(String text) {
    return fw.Padding(
      padding: const fw.EdgeInsets.only(
        left: AppDesignTokens.tinyGap,
        bottom: AppDesignTokens.itemGap,
      ),
      child: fw.Text(
        text.toUpperCase(),
        style: fw.TextStyle(
          fontSize: AppDesignTokens.smallCaptionFontSize,
          fontWeight: AppDesignTokens.bold,
          letterSpacing: 1.4,
          color: AppDesignTokens.mutedTextColor,
        ),
      ),
    );
  }

  void _push(fw.BuildContext context, fw.Widget screen) {
    fw.Navigator.push(
      context,
      fw.PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}

/// Elevated navigation row: tinted icon tile + title + subtitle + optional
/// ember badge + chevron.
class _MenuRow extends fw.StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String subtitle;
  final fw.Color color;
  final fw.VoidCallback onTap;
  final int animationIndex;
  final int? badge;

  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.animationIndex,
    this.badge,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    return fw.Padding(
      padding: const fw.EdgeInsets.only(bottom: AppDesignTokens.itemGap),
      child: FadeSlideIn(
        index: animationIndex,
        child: AppCard(
          onTap: onTap,
          elevated: true,
          padding: const fw.EdgeInsets.all(AppDesignTokens.itemGap + 2),
          child: fw.Row(
            children: [
              AppIconChip(icon: icon, color: color, size: 22),
              const fw.SizedBox(width: AppDesignTokens.cardGap),
              fw.Expanded(
                child: fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  mainAxisSize: fw.MainAxisSize.min,
                  children: [
                    fw.Text(
                      title,
                      style: const fw.TextStyle(
                        fontSize: AppDesignTokens.cardTitleFontSize - 1,
                        fontWeight: AppDesignTokens.semiBold,
                        height: 1.2,
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.tinyGap),
                    fw.Text(
                      subtitle,
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.captionFontSize,
                        fontWeight: AppDesignTokens.regular,
                        color: theme.colorScheme.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null) ...[
                const fw.SizedBox(width: AppDesignTokens.smallGap),
                fw.Container(
                  padding: const fw.EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 3,
                  ),
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.primaryColor,
                    borderRadius:
                        fw.BorderRadius.circular(AppDesignTokens.pillRadius),
                  ),
                  child: fw.Text(
                    '$badge',
                    style: fw.TextStyle(
                      fontSize: AppDesignTokens.smallCaptionFontSize,
                      fontWeight: AppDesignTokens.bold,
                      color: AppDesignTokens.onAccentColor,
                      fontFeatures: AppDesignTokens.tabularFigures,
                    ),
                  ),
                ),
              ],
              const fw.SizedBox(width: AppDesignTokens.smallGap),
              fw.Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: theme.colorScheme.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
