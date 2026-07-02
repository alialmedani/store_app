import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../auth/cubit/auth_cubit.dart';
import '../../auth/screen/login_screen_shadcn.dart';
import '../../category/screen/category_list_screen.dart';
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          currentUser?.userName ?? 'User',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_outlined),
                          onPressed: () {
                            // TODO: Navigate to notifications
                          },
                          variance: ButtonVariance.ghost,
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Quick Stats
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.category_outlined,
                        title: 'Categories',
                        value: '--',
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.inventory_2_outlined,
                        title: 'Products',
                        value: '--',
                        color: const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Main Menu
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Main Menu',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // Menu Items
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
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
                          builder: (context) => const ProductVariantListScreen(),
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
                      // TODO: Navigate to orders
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Coming Soon'),
                          content: const Text(
                            'Orders feature will be available soon.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('OK'),
                            ),
                          ],
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
