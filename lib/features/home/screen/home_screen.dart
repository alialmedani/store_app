import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../auth/screen/login_screen_shadcn.dart';
import '../../category/screen/category_list_screen.dart';
import '../../order/cubit/order_cubit.dart';
import '../../order/screen/order_list_screen.dart';
import '../../product/screen/product_list_screen.dart';
import '../../product_variant/screen/product_variant_list_screen.dart';

/// Home Screen - Main dashboard after login
/// Uses shadcn_flutter components with clean, modern design
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
            // App Bar
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  border: Border(
                    bottom: BorderSide(
                      color: theme.colorScheme.border.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.mutedForeground,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentUser?.userName ?? 'User',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.muted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.notifications_outlined, size: 20),
                            onPressed: () {
                              // TODO: Navigate to notifications
                            },
                            variance: ButtonVariance.ghost,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.muted.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.logout, size: 20),
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
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    DestructiveButton(
                                      onPressed: () => Navigator.pop(ctx, true),
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
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreenShadcn(),
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
              ),
            ),

            // Quick Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.category_outlined,
                        title: 'Categories',
                        value: '—',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Products',
                        value: '—',
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Menu
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Main Menu',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Menu Items
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.15,
                ),
                delegate: SliverChildListDelegate([
                  _MenuCard(
                    icon: Icons.category,
                    title: 'Categories',
                    subtitle: 'Manage categories',
                    color: theme.colorScheme.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoryListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    icon: Icons.inventory_2,
                    title: 'Products',
                    subtitle: 'Manage products',
                    color: const Color(0xFF10B981),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    icon: Icons.style,
                    title: 'Product Variants',
                    subtitle: 'Manage variants',
                    color: const Color(0xFF06B6D4),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProductVariantListScreen(),
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    icon: Icons.shopping_cart,
                    title: 'Orders',
                    subtitle: 'View orders',
                    color: const Color(0xFF8B5CF6),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (_) => OrderCubit(),
                            child: const OrderListScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                  _MenuCard(
                    icon: Icons.bar_chart,
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
                              onPressed: () => Navigator.pop(ctx),
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

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.border.withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.mutedForeground,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu Card Widget
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.border.withOpacity(0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: color),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
