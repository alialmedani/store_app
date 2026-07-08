import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
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
                              size: 20,
                            ),
                            onPressed: () {
                              // TODO: Navigate to notifications
                            },
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                        const fw.SizedBox(width: AppDesignTokens.smallGap + 2),
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
                            icon: const fw.Icon(Icons.logout, size: 20),
                            onPressed: () => _handleLogout(context, authCubit),
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
                      'Welcome Back',
                      style: fw.TextStyle(
                        fontSize: AppDesignTokens.bodyFontSize,
                        fontWeight: AppDesignTokens.semiBold,
                        color: theme.colorScheme.mutedForeground,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.smallGap),
                    fw.Text(
                      currentUser?.userName ?? 'User',
                      style: const fw.TextStyle(
                        fontSize: 32,
                        fontWeight: AppDesignTokens.extraBold,
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                    ),
                    const fw.SizedBox(height: AppDesignTokens.smallGap),
                    fw.Text(
                      'Manage your store efficiently',
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
                            icon: Icons.inventory_2_rounded,
                            title: 'Total Products',
                            value: '${summary.totalProducts ?? 0}',
                            color: const fw.Color(0xFF10B981),
                            subtitle: '${summary.activeProducts ?? 0} active',
                          ),
                        ),
                        const fw.SizedBox(width: AppDesignTokens.cardGap),
                        fw.Expanded(
                          child: StatCard(
                            icon: Icons.style_rounded,
                            title: 'Total Variants',
                            value: '${summary.totalVariants ?? 0}',
                            color: const fw.Color(0xFF06B6D4),
                            subtitle: '${summary.activeVariants ?? 0} active',
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
                            icon: Icons.check_circle_rounded,
                            title: 'In Stock',
                            value: '${summary.instockProducts ?? 0}',
                            color: AppDesignTokens.successColor,
                            subtitle:
                                '${summary.instockVariants ?? 0} variants',
                          ),
                        ),
                        const fw.SizedBox(width: AppDesignTokens.cardGap),
                        fw.Expanded(
                          child: StatCard(
                            icon: Icons.warning_rounded,
                            title: 'Low Stock',
                            value: '${summary.lowStockProducts ?? 0}',
                            color: AppDesignTokens.warningColor,
                            subtitle: 'Needs attention',
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
                const fw.Text(
                  'Main Menu',
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
                icon: Icons.category_rounded,
                title: 'Categories',
                subtitle: 'Manage categories',
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
                icon: Icons.inventory_2_rounded,
                title: 'Products',
                subtitle: 'Manage products',
                color: const fw.Color(0xFF10B981),
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
                icon: Icons.style_rounded,
                title: 'Product Variants',
                subtitle: 'Manage variants',
                color: const fw.Color(0xFF06B6D4),
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
                icon: Icons.shopping_cart_rounded,
                title: 'Orders',
                subtitle: 'View orders',
                color: const fw.Color(0xFF8B5CF6),
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
                icon: Icons.warehouse_rounded,
                title: 'Inventory',
                subtitle: 'Stock movements',
                color: const fw.Color(0xFFEC4899),
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
                icon: Icons.assessment_rounded,
                title: 'Category Stock',
                subtitle: 'Stock by category',
                color: const fw.Color(0xFF8B5CF6),
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
                icon: Icons.bar_chart_rounded,
                title: 'Reports',
                subtitle: 'View analytics',
                color: const fw.Color(0xFFF59E0B),
                onTap: () {
                  // TODO: Navigate to reports
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Coming Soon'),
                      content: const Text(
                        'Reports feature will be available soon.',
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
            ]),
          ),
        ),

        const SliverToBoxAdapter(
          child: fw.SizedBox(height: AppDesignTokens.sectionGap + 12),
        ),
      ],
    );
  }

  Future<void> _handleLogout(fw.BuildContext context, AuthCubit authCubit) async {
    // Show logout confirmation dialog
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
