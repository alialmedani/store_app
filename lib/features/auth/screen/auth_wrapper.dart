import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import '../../../core/classes/cashe_helper.dart';
import '../../home/screen/main_navigation_screen.dart';
import '../cubit/auth_cubit.dart';
import 'login_screen_shadcn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store/core/ui/shadcn/widget/design_system/app_skeleton_loader.dart';

/// Auth Wrapper - Checks if user is already logged in
/// Shows MainNavigationScreen if token exists, otherwise shows LoginScreen
class AuthWrapper extends fw.StatefulWidget {
  const AuthWrapper({super.key});

  @override
  fw.State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends fw.State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Small delay to show splash effect
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    // Check if token exists
    final token = CacheHelper.token;
    final tokenExpiry = CacheHelper.datenow;

    // Check if token is valid
    bool isTokenValid = false;
    if (token != null && token.isNotEmpty) {
      if (tokenExpiry != null) {
        // Check if token hasn't expired
        isTokenValid = tokenExpiry.isAfter(DateTime.now());
      } else {
        // If no expiry date, consider token valid
        isTokenValid = true;
      }
    }

    // For returning users (valid cached token) the current user & granted
    // permissions are not in memory yet (only fetched at login). Best-effort
    // refresh so permission-gated UI (e.g. Reports) knows what to show. Never
    // block or fail navigation on this.
    if (isTokenValid && mounted) {
      try {
        final authCubit = context.read<AuthCubit>();
        final result = await authCubit.getAppConfig();
        if (result.hasDataOnly) {
          authCubit.currentUser = result.data;
        }
      } catch (_) {
        // ignore — gating falls back to backend 403 enforcement
      }
    }

    if (!mounted) return;

    // Navigate based on token validity
    if (mounted) {
      if (isTokenValid) {
        // Token exists and is valid - go to main navigation
        fw.Navigator.pushReplacement(
          context,
          fw.PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const MainNavigationScreen(),
            transitionDuration: Duration.zero,
          ),
        );
      } else {
        // No token or expired - go to login
        fw.Navigator.pushReplacement(
          context,
          fw.PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const LoginScreenShadcn(),
            transitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    // Show a loading splash screen while checking auth status
    return Scaffold(
      child: fw.Center(
        child: fw.Column(
          mainAxisAlignment: fw.MainAxisAlignment.center,
          children: [
            // Logo
            fw.Container(
              padding: const fw.EdgeInsets.all(24),
              decoration: fw.BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: fw.BorderRadius.circular(20),
              ),
              child: Icon(
                RadixIcons.backpack,
                size: 80,
                color: theme.colorScheme.primary,
              ),
            ),
            const fw.SizedBox(height: 32),

            // App Title
            Text(
              'store_management'.tr(),
              style: TextStyle(fontSize: 28, fontWeight: fw.FontWeight.bold),
            ),
            const fw.SizedBox(height: 48),

            // Loading Indicator
            const AppSkeletonBox(width: 160, height: 10, borderRadius: 99),
          ],
        ),
      ),
    );
  }
}
