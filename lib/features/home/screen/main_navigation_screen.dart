import 'package:store/core/ui/kit/app_kit.dart';
import 'package:flutter/widgets.dart' as fw;

import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'home_screen.dart';
import 'dashboard_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'explore_screen.dart';
import 'package:easy_localization/easy_localization.dart';

/// Main Navigation Screen with an ink pill bottom nav (Ink & Ember):
/// outline icons, the active item sits inside a filled ember circle.
class MainNavigationScreen extends fw.StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  fw.State<MainNavigationScreen> createState() => _MainNavigationScreenState();
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

  static List<_NavDef> get _items => [
    _NavDef(Icons.home_outlined, 'home'.tr()),
    _NavDef(Icons.explore_outlined, 'explore'.tr()),
    _NavDef(Icons.dashboard_outlined, 'dashboard'.tr()),
    _NavDef(Icons.shopping_bag_outlined, 'cart'.tr()),
    _NavDef(Icons.person_outline, 'profile'.tr()),
  ];

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    final mq = fw.MediaQuery.of(context);
    // Space reserved so scrollable content ends above the floating dock
    const dockSpace = 92.0;

    return fw.Stack(
      children: [
        fw.Positioned.fill(
          child: DockInset(
            bottom: dockSpace + mq.padding.bottom,
            child: fw.AnimatedSwitcher(
              duration: AppDesignTokens.motionBase,
              switchInCurve: AppDesignTokens.easeOut,
              child: fw.KeyedSubtree(
                key: fw.ValueKey<int>(_currentIndex),
                child: _screens[_currentIndex],
              ),
            ),
          ),
        ),
        fw.Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: fw.SafeArea(
            top: false,
            child: fw.Padding(
              padding: const fw.EdgeInsets.fromLTRB(18, 6, 18, 14),
              child: fw.Container(
                height: 66,
                padding: const fw.EdgeInsets.symmetric(horizontal: 10),
                decoration: fw.BoxDecoration(
                  color: AppDesignTokens.navBackgroundColor,
                  borderRadius: fw.BorderRadius.circular(26),
                  boxShadow: const [
                    fw.BoxShadow(
                      color: fw.Color(0x47000000),
                      blurRadius: 36,
                      offset: fw.Offset(0, 16),
                    ),
                  ],
                ),
                child: fw.Row(
                  mainAxisAlignment: fw.MainAxisAlignment.spaceAround,
                  children: [
                    for (var i = 0; i < _items.length; i++)
                      _buildNavItem(_items[i], i, theme),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  fw.Widget _buildNavItem(_NavDef def, int index, ThemeData theme) {
    final isSelected = _currentIndex == index;

    return PressScale(
      pressedScale: 0.9,
      onTap: () {
        if (_currentIndex != index) setState(() => _currentIndex = index);
      },
      child: fw.AnimatedContainer(
        duration: AppDesignTokens.motionBase,
        curve: AppDesignTokens.easeOut,
        width: 46,
        height: 46,
        decoration: fw.BoxDecoration(
          shape: fw.BoxShape.circle,
          color: isSelected ? AppDesignTokens.primaryColor : null,
          boxShadow: isSelected ? AppDesignTokens.glowShadow : null,
        ),
        child: fw.Icon(
          def.icon,
          size: 22,
          color: isSelected
              ? AppDesignTokens.onAccentColor
              : AppDesignTokens.navMutedColor,
        ),
      ),
    );
  }
}

class _NavDef {
  final fw.IconData icon;
  final String label;
  const _NavDef(this.icon, this.label);
}
