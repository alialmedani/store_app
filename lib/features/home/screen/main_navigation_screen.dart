import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/widgets.dart' as fw;

import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';

/// Main Navigation Screen with Bottom Navigation Bar
class MainNavigationScreen extends fw.StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  fw.State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends fw.State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<fw.Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const DashboardScreen(),
    const CartScreen(),
    const ProfileScreen(),
  ];

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return fw.Column(
      children: [
        fw.Expanded(
          child: _screens[_currentIndex],
        ),
        // Bottom Navigation Bar
        fw.Container(
          decoration: fw.BoxDecoration(
            color: theme.colorScheme.background,
            border: fw.Border(
              top: fw.BorderSide(
                color: theme.colorScheme.border.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              fw.BoxShadow(
                color: theme.colorScheme.foreground.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const fw.Offset(0, -2),
              ),
            ],
          ),
          child: fw.SafeArea(
            top: false,
            child: fw.Padding(
              padding: const fw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              child: fw.Row(
                mainAxisAlignment: fw.MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.explore_rounded,
                    label: 'Explore',
                    index: 1,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    index: 2,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.shopping_cart_rounded,
                    label: 'Cart',
                    index: 3,
                    theme: theme,
                  ),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    index: 4,
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  fw.Widget _buildNavItem({
    required fw.IconData icon,
    required String label,
    required int index,
    required ThemeData theme,
  }) {
    final isSelected = _currentIndex == index;

    return fw.Expanded(
      child: fw.GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: fw.HitTestBehavior.opaque,
        child: fw.Container(
          padding: const fw.EdgeInsets.symmetric(vertical: 8),
          child: fw.Column(
            mainAxisSize: fw.MainAxisSize.min,
            children: [
              fw.Container(
                padding: const fw.EdgeInsets.all(8),
                decoration: fw.BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.12)
                      : const fw.Color(0x00000000),
                  borderRadius: fw.BorderRadius.circular(12),
                ),
                child: fw.Icon(
                  icon,
                  size: 24,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.mutedForeground,
                ),
              ),
              const fw.SizedBox(height: 4),
              fw.Text(
                label,
                style: fw.TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? fw.FontWeight.w600 : fw.FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.mutedForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
