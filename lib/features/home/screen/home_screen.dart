import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../cubit/home_cubit.dart';
import '../data/model/dashboard_summary_model.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/screen/login_screen_shadcn.dart';
import '../../category/screen/category_list_screen.dart';
import '../../inventory/cubit/inventory_cubit.dart';
import '../../inventory/screen/inventory_list_screen.dart';
import '../../order/cubit/order_cubit.dart';
import '../../order/screen/order_list_screen.dart';
import '../../product/screen/product_list_screen.dart';
import '../../product_variant/screen/product_variant_list_screen.dart';

/// Home Screen - Premium Main Dashboard
/// Modern, clean design with gradients and premium shadcn components
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authCubit = context.read<AuthCubit>();
    final currentUser = authCubit.currentUser;

    return Scaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Premium App Bar with Gradient
            SliverToBoxAdapter(
              child: fw.Container(
                padding: const fw.EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: fw.BoxDecoration(
                  gradient: fw.LinearGradient(
                    begin: fw.Alignment.topLeft,
                    end: fw.Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.background,
                      theme.colorScheme.background.withOpacity(0.95),
                    ],
                  ),
                  border: fw.Border(
                    bottom: fw.BorderSide(
                      color: theme.colorScheme.border.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                  boxShadow: [
                    fw.BoxShadow(
                      color: theme.colorScheme.foreground.withOpacity(0.02),
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
                          padding: const fw.EdgeInsets.all(12),
                          decoration: fw.BoxDecoration(
                            gradient: fw.LinearGradient(
                              begin: fw.Alignment.topLeft,
                              end: fw.Alignment.bottomRight,
                              colors: [
                                theme.colorScheme.primary.withOpacity(0.15),
                                theme.colorScheme.primary.withOpacity(0.08),
                              ],
                            ),
                            borderRadius: fw.BorderRadius.circular(14),
                            border: fw.Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.2),
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
                                color: theme.colorScheme.muted.withOpacity(0.25),
                                borderRadius: fw.BorderRadius.circular(12),
                                border: fw.Border.all(
                                  color: theme.colorScheme.border.withOpacity(0.1),
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
                            const fw.SizedBox(width: 10),
                            fw.Container(
                              decoration: fw.BoxDecoration(
                                color: theme.colorScheme.muted.withOpacity(0.25),
                                borderRadius: fw.BorderRadius.circular(12),
                                border: fw.Border.all(
                                  color: theme.colorScheme.border.withOpacity(0.1),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: const fw.Icon(Icons.logout, size: 20),
                                onPressed: () async {
                                  // Show logout confirmation dialog
                                  final shouldLogout = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Logout'),
                                      content: const Text(
                                        'Are you sure you want to logout?',
                                      ),
                                      actions: [
                                        SecondaryButton(
                                          onPressed: () =>
                                              fw.Navigator.pop(ctx, false),
                                          child: const Text('Cancel'),
                                        ),
                                        DestructiveButton(
                                          onPressed: () =>
                                              fw.Navigator.pop(ctx, true),
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
                                          pageBuilder: (_, __, ___) =>
                                              const LoginScreenShadcn(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                                variance: ButtonVariance.ghost,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const fw.SizedBox(height: 24),
                    // Welcome Message
                    fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.start,
                      children: [
                        fw.Text(
                          'Welcome Back',
                          style: fw.TextStyle(
                            fontSize: 14,
                            fontWeight: fw.FontWeight.w600,
                            color: theme.colorScheme.mutedForeground,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const fw.SizedBox(height: 8),
                        fw.Text(
                          currentUser?.userName ?? 'User',
                          style: const fw.TextStyle(
                            fontSize: 32,
                            fontWeight: fw.FontWeight.w800,
                            letterSpacing: -1,
                            height: 1.1,
                          ),
                        ),
                        const fw.SizedBox(height: 8),
                        fw.Text(
                          'Manage your store efficiently',
                          style: fw.TextStyle(
                            fontSize: 14,
                            fontWeight: fw.FontWeight.w500,
                            color: theme.colorScheme.mutedForeground,
                            letterSpacing: 0.1,
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
                padding: const fw.EdgeInsets.fromLTRB(24, 28, 24, 32),
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
                              child: _StatCard(
                                icon: Icons.inventory_2_rounded,
                                title: 'Total Products',
                                value: '${summary.totalProducts ?? 0}',
                                color: const Color(0xFF10B981),
                                subtitle:
                                    '${summary.activeProducts ?? 0} active',
                              ),
                            ),
                            const fw.SizedBox(width: 16),
                            fw.Expanded(
                              child: _StatCard(
                                icon: Icons.style_rounded,
                                title: 'Total Variants',
                                value: '${summary.totalVariants ?? 0}',
                                color: const Color(0xFF06B6D4),
                                subtitle:
                                    '${summary.activeVariants ?? 0} active',
                              ),
                            ),
                          ],
                        ),
                        const fw.SizedBox(height: 16),
                        // Second Row: Stock Status
                        fw.Row(
                          children: [
                            fw.Expanded(
                              child: _StatCard(
                                icon: Icons.check_circle_rounded,
                                title: 'In Stock',
                                value: '${summary.instockProducts ?? 0}',
                                color: theme.colorScheme.primary,
                                subtitle:
                                    '${summary.instockVariants ?? 0} variants',
                              ),
                            ),
                            const fw.SizedBox(width: 16),
                            fw.Expanded(
                              child: _StatCard(
                                icon: Icons.warning_rounded,
                                title: 'Low Stock',
                                value: '${summary.lowStockProducts ?? 0}',
                                color: const Color(0xFFF59E0B),
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
                padding: const fw.EdgeInsets.symmetric(horizontal: 24),
                child: fw.Row(
                  children: [
                    fw.Container(
                      width: 4,
                      height: 24,
                      decoration: fw.BoxDecoration(
                        gradient: fw.LinearGradient(
                          begin: fw.Alignment.topCenter,
                          end: fw.Alignment.bottomCenter,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.5),
                          ],
                        ),
                        borderRadius: fw.BorderRadius.circular(2),
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    const fw.Text(
                      'Main Menu',
                      style: fw.TextStyle(
                        fontSize: 22,
                        fontWeight: fw.FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: fw.SizedBox(height: 20)),

            // Premium Menu Items Grid
            SliverPadding(
              padding: const fw.EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                delegate: SliverChildListDelegate([
                  _MenuCard(
                    icon: Icons.category_rounded,
                    title: 'Categories',
                    subtitle: 'Manage categories',
                    color: theme.colorScheme.primary,
                    onTap: () {
                      fw.Navigator.push(
                        context,
                        fw.PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              const CategoryListScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    icon: Icons.inventory_2_rounded,
                    title: 'Products',
                    subtitle: 'Manage products',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      fw.Navigator.push(
                        context,
                        fw.PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              const ProductListScreen(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    icon: Icons.style_rounded,
                    title: 'Product Variants',
                    subtitle: 'Manage variants',
                    color: const Color(0xFF06B6D4),
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
                  _MenuCard(
                    icon: Icons.shopping_cart_rounded,
                    title: 'Orders',
                    subtitle: 'View orders',
                    color: const Color(0xFF8B5CF6),
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
                  _MenuCard(
                    icon: Icons.warehouse_rounded,
                    title: 'Inventory',
                    subtitle: 'Stock movements',
                    color: const Color(0xFFEC4899),
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
                  _MenuCard(
                    icon: Icons.bar_chart_rounded,
                    title: 'Reports',
                    subtitle: 'View analytics',
                    color: const Color(0xFFF59E0B),
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

            const SliverToBoxAdapter(child: fw.SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

/// Premium Stat Card Widget with Gradient
class _StatCard extends StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String value;
  final Color color;
  final String? subtitle;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.subtitle,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: fw.Container(
        decoration: fw.BoxDecoration(
          borderRadius: fw.BorderRadius.circular(16),
          gradient: fw.LinearGradient(
            begin: fw.Alignment.topLeft,
            end: fw.Alignment.bottomRight,
            colors: [
              theme.colorScheme.card,
              theme.colorScheme.card.withOpacity(0.98),
            ],
          ),
          border: fw.Border.all(
            color: color.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            fw.BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 12,
              offset: const fw.Offset(0, 4),
            ),
          ],
        ),
        child: fw.Padding(
          padding: const fw.EdgeInsets.all(20),
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              fw.Container(
                padding: const fw.EdgeInsets.all(12),
                decoration: fw.BoxDecoration(
                  gradient: fw.LinearGradient(
                    begin: fw.Alignment.topLeft,
                    end: fw.Alignment.bottomRight,
                    colors: [
                      color.withOpacity(0.15),
                      color.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: fw.BorderRadius.circular(12),
                  border: fw.Border.all(
                    color: color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: fw.Icon(icon, size: 24, color: color),
              ),
              const fw.SizedBox(height: 18),
              fw.Text(
                title,
                style: fw.TextStyle(
                  fontSize: 13,
                  fontWeight: fw.FontWeight.w600,
                  color: theme.colorScheme.mutedForeground,
                  letterSpacing: 0.3,
                ),
              ),
              const fw.SizedBox(height: 8),
              fw.Text(
                value,
                style: const fw.TextStyle(
                  fontSize: 30,
                  fontWeight: fw.FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1,
                ),
              ),
              if (subtitle != null) ...[
                const fw.SizedBox(height: 6),
                fw.Text(
                  subtitle!,
                  style: fw.TextStyle(
                    fontSize: 12,
                    fontWeight: fw.FontWeight.w500,
                    color: theme.colorScheme.mutedForeground,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Premium Menu Card Widget with Enhanced Styling
class _MenuCard extends StatelessWidget {
  final fw.IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final fw.VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.GestureDetector(
      onTap: onTap,
      child: Card(
        child: fw.Container(
          decoration: fw.BoxDecoration(
            borderRadius: fw.BorderRadius.circular(16),
            gradient: fw.LinearGradient(
              begin: fw.Alignment.topLeft,
              end: fw.Alignment.bottomRight,
              colors: [
                theme.colorScheme.card,
                theme.colorScheme.card.withOpacity(0.98),
              ],
            ),
            border: fw.Border.all(
              color: color.withOpacity(0.12),
              width: 1,
            ),
            boxShadow: [
              fw.BoxShadow(
                color: color.withOpacity(0.06),
                blurRadius: 12,
                offset: const fw.Offset(0, 4),
              ),
            ],
          ),
          child: fw.Padding(
            padding: const fw.EdgeInsets.all(18),
            child: fw.Column(
              crossAxisAlignment: fw.CrossAxisAlignment.start,
              mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
              children: [
                // Icon Container with Gradient
                fw.Container(
                  padding: const fw.EdgeInsets.all(12),
                  decoration: fw.BoxDecoration(
                    gradient: fw.LinearGradient(
                      begin: fw.Alignment.topLeft,
                      end: fw.Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.15),
                        color.withOpacity(0.08),
                      ],
                    ),
                    borderRadius: fw.BorderRadius.circular(12),
                    border: fw.Border.all(
                      color: color.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: fw.Icon(icon, size: 26, color: color),
                ),
                // Title and Subtitle
                fw.Column(
                  crossAxisAlignment: fw.CrossAxisAlignment.start,
                  children: [
                    fw.Text(
                      title,
                      style: const fw.TextStyle(
                        fontSize: 16,
                        fontWeight: fw.FontWeight.w700,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                    const fw.SizedBox(height: 4),
                    fw.Text(
                      subtitle,
                      style: fw.TextStyle(
                        fontSize: 12,
                        fontWeight: fw.FontWeight.w500,
                        color: theme.colorScheme.mutedForeground,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
