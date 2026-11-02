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
import 'package:easy_localization/easy_localization.dart';

/// Dashboard Screen - Premium Main Dashboard with Stats & Menu
class DashboardScreen extends fw.StatelessWidget {
  const DashboardScreen({super.key});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentUser;

    return AppSliverScreen(
      slivers: [
        // Premium App Bar with Gradient
        SliverToBoxAdapter(
          child: fw.Container(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal + 8,
              AppDesignTokens.screenPaddingHorizontal + 8,
              AppDesignTokens.screenPaddingHorizontal + 8,
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
              boxShadow: [
                fw.BoxShadow(
                  color: theme.colorScheme.foreground.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const fw.Offset(0, 2),
                ),
              ],
            ),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              children: [
                // Top bar with logout button
                fw.Row(
                  mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
                  children: [
                    fw.Container(
                      padding: const fw.EdgeInsets.all(
                        AppDesignTokens.iconBoxPadding,
                      ),
                      decoration: fw.BoxDecoration(
                        gradient: fw.LinearGradient(
                          begin: fw.Alignment.topLeft,
                          end: fw.Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                            theme.colorScheme.primary.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: fw.BorderRadius.circular(
                          AppDesignTokens.buttonRadius,
                        ),
                        border: fw.Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          width: 1,
                        ),
                      ),
                      child: fw.Icon(
                        Icons.storefront_rounded,
                        size: 28,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    fw.Row(
                      children: [
                        fw.Container(
                          decoration: fw.BoxDecoration(
                            color: theme.colorScheme.muted.withValues(
                              alpha: 0.25,
                            ),
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
                            icon: const fw.Icon(
                              Icons.notifications_outlined,
                              size: 20),
                            onPressed: () {},
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const fw.SizedBox(height: AppDesignTokens.sectionGap + 4),
                // Welcome Message
                fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    fw.Text(
                      'welcome_back'.tr(),
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.bodyFontSize,
                        fontWeight: AppDesignTokens.semiBold,
                        color: theme.colorScheme.mutedForeground,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.smallGap),
                    fw.Text(
                      currentUser?.userName ?? 'user'.tr(),
                      style: const fw.TextStyle(
                        fontSize: 32,
                        fontWeight: AppDesignTokens.extraBold,
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.smallGap),
                    fw.Text(
                      'manage_your_store_efficiently'.tr(),
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.bodyFontSize,
                        fontWeight: AppDesignTokens.medium,
                        color: theme.colorScheme.mutedForeground,
                        letterSpacing: AppDesignTokens.bodyLetterSpacing,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Premium Quick Stats
        SliverToBoxAdapter(
          child: fw.Padding(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.sectionGap + 8,
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.sectionGap + 12,
            ),
            child: GetModel<DashboardSummaryModel>(
              useCaseCallBack: () {
                return context.read<HomeCubit>().getDashboardSummary();
              },
              modelBuilder: (summary) {
                return fw.Column(
                  children: [
                    // First Row: Products and Variants
                    fw.Row(
                      children: [
                        fw.Expanded(
                          child: StatCard(
                            animationIndex: 0,
                            icon: Icons.inventory_2_rounded,
                            title: 'total_products'.tr(),
                            value: '${summary.totalProducts ?? 0}',
                            color: AppDesignTokens.successColor,
                            subtitle: 'active_2'.tr(args: ['${summary.activeProducts ?? 0}']),
                          ),
                        ),
                        const fw.SizedBox(width: AppDesignTokens.cardGap),
                        fw.Expanded(
                          child: StatCard(
                            animationIndex: 1,
                            icon: Icons.style_rounded,
                            title: 'total_variants'.tr(),
                            value: '${summary.totalVariants ?? 0}',
                            color: AppDesignTokens.infoColor,
                            subtitle: 'active_2'.tr(args: ['${summary.activeVariants ?? 0}']),
                          ),
                        ),
                      ],
                    ),
                    const fw.SizedBox(height: AppDesignTokens.cardGap),
                    // Second Row: Stock Status
                    fw.Row(
                      children: [
                        fw.Expanded(
                          child: StatCard(
                            animationIndex: 2,
                            icon: Icons.check_circle_rounded,
                            title: 'in_stock'.tr(),
                            value: '${summary.instockProducts ?? 0}',
                            color: AppDesignTokens.successColor,
                            subtitle:
                                'variants_2'.tr(args: ['${summary.instockVariants ?? 0}']),
                          ),
                        ),
                        const fw.SizedBox(width: AppDesignTokens.cardGap),
                        fw.Expanded(
                          child: StatCard(
                            animationIndex: 3,
                            icon: Icons.warning_rounded,
                            title: 'low_stock'.tr(),
                            value: '${summary.lowStockProducts ?? 0}',
                            color: AppDesignTokens.warningColor,
                            subtitle: 'needs_attention'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Main Menu Header
        SliverToBoxAdapter(
          child: fw.Padding(
            padding: const fw.EdgeInsets.fromLTRB(
              AppDesignTokens.screenPaddingHorizontal,
              AppDesignTokens.tinyGap,
              AppDesignTokens.screenPaddingHorizontal,
              0,
            ),
            child: fw.Row(
              crossAxisAlignment: fw.CrossAxisAlignment.center,
              children: [
                fw.Container(
                  width: 3,
                  height: 22,
                  decoration: fw.BoxDecoration(
                    gradient: fw.LinearGradient(
                      begin: fw.Alignment.topCenter,
                      end: fw.Alignment.bottomCenter,
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withValues(alpha: 0.5),
                      ],
                    ),
                    borderRadius: fw.BorderRadius.circular(1.5),
                  ),
                ),
                const fw.SizedBox(width: AppDesignTokens.itemGap),
                fw.Text(
                  'main_menu'.tr(),
                  style: fw.TextStyle(
                    fontSize: AppDesignTokens.largeTitleFontSize,
                    fontWeight: AppDesignTokens.extraBold,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(
          child: fw.SizedBox(height: AppDesignTokens.cardGap + 2),
        ),

        // Premium Menu Items Grid
        SliverPadding(
          padding: const fw.EdgeInsets.symmetric(
            horizontal: AppDesignTokens.screenPaddingHorizontal,
          ),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              mainAxisExtent: 145,
            ),
            delegate: SliverChildListDelegate([
              MenuTile(
                animationIndex: 0,
                icon: Icons.category_rounded,
                title: 'categories'.tr(),
                subtitle: 'manage_categories'.tr(),
                color: theme.colorScheme.primary,
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CategoryListScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              MenuTile(
                animationIndex: 1,
                icon: Icons.inventory_2_rounded,
                title: 'products'.tr(),
                subtitle: 'manage_products'.tr(),
                color: AppDesignTokens.successColor,
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const ProductListScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              MenuTile(
                animationIndex: 2,
                icon: Icons.style_rounded,
                title: 'product_variants'.tr(),
                subtitle: 'manage_variants'.tr(),
                color: AppDesignTokens.infoColor,
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          const ProductVariantListScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              MenuTile(
                animationIndex: 3,
                icon: Icons.shopping_cart_rounded,
                title: 'orders'.tr(),
                subtitle: 'view_orders'.tr(),
                color: AppDesignTokens.accentSecondaryColor,
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => BlocProvider(
                        create: (_) => OrderCubit(),
                        child: const OrderListScreen(),
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              MenuTile(
                animationIndex: 4,
                icon: Icons.warehouse_rounded,
                title: 'inventory'.tr(),
                subtitle: 'stock_movements'.tr(),
                color: const fw.Color(0xFFFF7AB6),
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => BlocProvider(
                        create: (_) => InventoryCubit(),
                        child: const InventoryListScreen(),
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              MenuTile(
                animationIndex: 5,
                icon: Icons.assessment_rounded,
                title: 'category_stock'.tr(),
                subtitle: 'stock_by_category'.tr(),
                color: AppDesignTokens.accentSecondaryColor,
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => BlocProvider(
                        create: (_) => CategoryCubit(),
                        child: const CategoryStockSummaryScreen(),
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
              ),
              MenuTile(
                animationIndex: 6,
                icon: Icons.bar_chart_rounded,
                title: 'reports'.tr(),
                subtitle: 'view_analytics'.tr(),
                color: AppDesignTokens.warningColor,
                onTap: () {
                  // TODO: Navigate to reports
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('coming_soon'.tr()),
                      content: Text(
                        'reports_feature_will_be_available_soon'.tr(),
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
            ]),
          ),
        ),

        const SliverToBoxAdapter(
          child: fw.SizedBox(height: AppDesignTokens.sectionGap + 12),
        ),
      ],
    );
  }

  Future<void> _handleLogout(
    fw.BuildContext context,
    AuthCubit authCubit,
  ) async {
    // Show logout confirmation dialog
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
      // Perform logout
      await authCubit.logout();

      // Navigate to login screen
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
