import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/classes/cashe_helper.dart';
import '../../home/screen/main_navigation_screen.dart';
import '../cubit/auth_cubit.dart';
import '../data/model/login_model.dart';
import 'register_screen_shadcn.dart';

/// Luxury Login Screen using shadcn_flutter components with clean architecture
/// Follows the CreateModel pattern from API_INTEGRATION_GUID.md
class LoginScreenShadcn extends fw.StatefulWidget {
  const LoginScreenShadcn({super.key});

  @override
  fw.State<LoginScreenShadcn> createState() => _LoginScreenShadcnState();
}

class _LoginScreenShadcnState extends fw.State<LoginScreenShadcn> {
  final _formKey = fw.GlobalKey<FormState>();
  final _usernameController = fw.TextEditingController();
  final _passwordController = fw.TextEditingController();
  bool _obscurePassword = true;
  String? _usernameError;
  String? _passwordError;

  bool _validateFields() {
    bool isValid = true;
    setState(() {
      // Validate username
      if (_usernameController.text.isEmpty) {
        _usernameError = 'Please enter your username or email';
        isValid = false;
      } else {
        _usernameError = null;
      }

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Please enter your password';
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        isValid = false;
      } else {
        _passwordError = null;
      }
    });
    return isValid;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      child: fw.SafeArea(
        child: fw.Stack(
          children: [
            // Premium Gradient Background
            fw.Positioned.fill(
              child: fw.Container(
                decoration: fw.BoxDecoration(
                  gradient: fw.LinearGradient(
                    begin: fw.Alignment.topLeft,
                    end: fw.Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.05),
                      theme.colorScheme.secondary.withValues(alpha: 0.03),
                      theme.colorScheme.primary.withValues(alpha: 0.08),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),

            // Decorative Elements
            fw.Positioned(
              top: -100,
              right: -100,
              child: fw.Container(
                width: 300,
                height: 300,
                decoration: fw.BoxDecoration(
                  shape: fw.BoxShape.circle,
                  gradient: fw.RadialGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.15),
                      theme.colorScheme.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            fw.Positioned(
              bottom: -150,
              left: -150,
              child: fw.Container(
                width: 400,
                height: 400,
                decoration: fw.BoxDecoration(
                  shape: fw.BoxShape.circle,
                  gradient: fw.RadialGradient(
                    colors: [
                      theme.colorScheme.secondary.withValues(alpha: 0.12),
                      theme.colorScheme.secondary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            fw.Center(
              child: fw.SingleChildScrollView(
                padding: const fw.EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: fw.Column(
                  mainAxisAlignment: fw.MainAxisAlignment.center,
                  children: [
                    // Logo with Premium Design
                    fw.Container(
                      padding: const fw.EdgeInsets.all(24),
                      decoration: fw.BoxDecoration(
                        gradient: fw.LinearGradient(
                          begin: fw.Alignment.topLeft,
                          end: fw.Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.15),
                            theme.colorScheme.primary.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: fw.BorderRadius.circular(28),
                        border: fw.Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          width: 1.5,
                        ),
                        boxShadow: [
                          fw.BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.1,
                            ),
                            blurRadius: 24,
                            offset: const fw.Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        RadixIcons.backpack,
                        size: 72,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const fw.SizedBox(height: 40),

                    // Premium Header
                    const Text(
                      'Store Management',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: fw.FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const fw.SizedBox(height: 12),
                    fw.Text(
                      'Welcome back! Sign in to continue',
                      style: fw.TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.mutedForeground,
                        fontWeight: fw.FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const fw.SizedBox(height: 56),

                    // Glassmorphic Form Card
                    fw.Container(
                      constraints: const fw.BoxConstraints(maxWidth: 440),
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.card.withValues(alpha: 0.7),
                        borderRadius: fw.BorderRadius.circular(24),
                        border: fw.Border.all(
                          color: theme.colorScheme.border.withValues(
                            alpha: 0.3,
                          ),
                          width: 1,
                        ),
                        boxShadow: [
                          fw.BoxShadow(
                            color: fw.Color(0x00000000).withValues(alpha: 0.08),
                            blurRadius: 32,
                            offset: const fw.Offset(0, 16),
                          ),
                        ],
                      ),
                      child: fw.Padding(
                        padding: const fw.EdgeInsets.all(32),
                        child: fw.Form(
                          key: _formKey,
                          child: fw.Column(
                            crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                            children: [
                              // Username Field with Premium Design
                              fw.Column(
                                crossAxisAlignment:
                                    fw.CrossAxisAlignment.start,
                                children: [
                                  fw.Text(
                                    'Username or Email',
                                    style: fw.TextStyle(
                                      fontSize: 14,
                                      fontWeight: fw.FontWeight.w600,
                                      color: theme.colorScheme.foreground,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 10),
                                  TextField(
                                    controller: _usernameController,
                                    placeholder: const Text(
                                      'Enter your username or email',
                                    ),
                                    onChanged: (value) {
                                      context
                                          .read<AuthCubit>()
                                          .loginParams
                                          .username = value;
                                      if (_usernameError != null) {
                                        setState(() {
                                          _usernameError = null;
                                        });
                                      }
                                    },
                                  ),
                                  if (_usernameError != null)
                                    fw.Padding(
                                      padding: const fw.EdgeInsets.only(top: 8),
                                      child: fw.Row(
                                        children: [
                                          Icon(
                                            RadixIcons.crossCircled,
                                            size: 14,
                                            color: theme.colorScheme.destructive,
                                          ),
                                          const fw.SizedBox(width: 6),
                                          Text(
                                            _usernameError!,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.destructive,
                                              fontSize: 13,
                                              fontWeight: fw.FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const fw.SizedBox(height: 24),

                              // Password Field with Premium Design
                              fw.Column(
                                crossAxisAlignment:
                                    fw.CrossAxisAlignment.start,
                                children: [
                                  fw.Row(
                                    mainAxisAlignment:
                                        fw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      fw.Text(
                                        'Password',
                                        style: fw.TextStyle(
                                          fontSize: 14,
                                          fontWeight: fw.FontWeight.w600,
                                          color: theme.colorScheme.foreground,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      fw.GestureDetector(
                                        onTap: () {
                                          // TODO: Implement forgot password
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: fw.FontWeight.w600,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const fw.SizedBox(height: 10),
                                  fw.Stack(
                                    alignment: fw.Alignment.centerRight,
                                    children: [
                                      TextField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        placeholder: const Text(
                                          'Enter your password',
                                        ),
                                        onChanged: (value) {
                                          context
                                              .read<AuthCubit>()
                                              .loginParams
                                              .password = value;
                                          if (_passwordError != null) {
                                            setState(() {
                                              _passwordError = null;
                                            });
                                          }
                                        },
                                      ),
                                      fw.Padding(
                                        padding: const fw.EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: fw.GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscurePassword =
                                                  !_obscurePassword;
                                            });
                                          },
                                          child: Icon(
                                            _obscurePassword
                                                ? RadixIcons.eyeOpen
                                                : RadixIcons.eyeClosed,
                                            size: 18,
                                            color: theme
                                                .colorScheme.mutedForeground,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_passwordError != null)
                                    fw.Padding(
                                      padding: const fw.EdgeInsets.only(top: 8),
                                      child: fw.Row(
                                        children: [
                                          Icon(
                                            RadixIcons.crossCircled,
                                            size: 14,
                                            color: theme.colorScheme.destructive,
                                          ),
                                          const fw.SizedBox(width: 6),
                                          Text(
                                            _passwordError!,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.destructive,
                                              fontSize: 13,
                                              fontWeight: fw.FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const fw.SizedBox(height: 32),

                              // Premium Login Button - Using CreateModel for state management
                              CreateModel<LoginModel>(
                                withValidation: true,
                                onTap: () {
                                  return _validateFields();
                                },
                                useCaseCallBack: (data) {
                                  return context.read<AuthCubit>().login();
                                },
                                onSuccess: (loginModel) async {
                                  // Save token and expiry info
                                  await CacheHelper.setToken(
                                    loginModel.accessToken,
                                  );
                                  await CacheHelper.setRefreshToken(
                                    loginModel.refreshToken,
                                  );
                                  await CacheHelper.setExpiresIn(
                                    loginModel.expiresIn ?? 3600,
                                  );
                                  await CacheHelper.setDateWithExpiry(
                                    loginModel.expiresIn ?? 3600,
                                  );

                                  // Fetch current user
                                  final authCubit = context.read<AuthCubit>();
                                  final userResult =
                                      await authCubit.getAppConfig();

                                  if (userResult.hasDataOnly) {
                                    authCubit.currentUser = userResult.data;

                                    // Navigate to main navigation
                                    if (context.mounted) {
                                      fw.Navigator.pushReplacement(
                                        context,
                                        fw.PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              const MainNavigationScreen(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
                                        ),
                                      );
                                    }
                                  } else {
                                    // Show error
                                    if (context.mounted) {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                            'Failed to load user data. Please try again.',
                                          ),
                                          actions: [
                                            PrimaryButton(
                                              onPressed: () =>
                                                  fw.Navigator.pop(ctx),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                onError: (error) {
                                  // Show error message
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: fw.Row(
                                          children: [
                                            Icon(
                                              RadixIcons.crossCircled,
                                              size: 24,
                                              color:
                                                  theme.colorScheme.destructive,
                                            ),
                                            const fw.SizedBox(width: 12),
                                            const Text('Login Failed'),
                                          ],
                                        ),
                                        content: Text('Error: $error'),
                                        actions: [
                                          PrimaryButton(
                                            onPressed: () =>
                                                fw.Navigator.pop(ctx),
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: fw.Container(
                                  decoration: fw.BoxDecoration(
                                    borderRadius: fw.BorderRadius.circular(12),
                                    boxShadow: [
                                      fw.BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withValues(alpha: 0.3),
                                        blurRadius: 16,
                                        offset: const fw.Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: PrimaryButton(
                                    child: fw.Padding(
                                      padding: const fw.EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: fw.Row(
                                        mainAxisAlignment:
                                            fw.MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Sign In',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: fw.FontWeight.w600,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const fw.SizedBox(width: 8),
                                          Icon(
                                            RadixIcons.arrowRight,
                                            size: 18,
                                            color: theme
                                                .colorScheme.primaryForeground,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const fw.SizedBox(height: 32),

                    // Premium Register Link
                    fw.Container(
                      padding: const fw.EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.muted.withValues(alpha: 0.3),
                        borderRadius: fw.BorderRadius.circular(16),
                        border: fw.Border.all(
                          color: theme.colorScheme.border.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      ),
                      child: fw.Row(
                        mainAxisAlignment: fw.MainAxisAlignment.center,
                        mainAxisSize: fw.MainAxisSize.min,
                        children: [
                          fw.Text(
                            "Don't have an account? ",
                            style: fw.TextStyle(
                              fontSize: 15,
                              color: theme.colorScheme.mutedForeground,
                              fontWeight: fw.FontWeight.w500,
                            ),
                          ),
                          fw.GestureDetector(
                            onTap: () {
                              fw.Navigator.push(
                                context,
                                fw.PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      const RegisterScreenShadcn(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 15,
                                color: theme.colorScheme.primary,
                                fontWeight: fw.FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
