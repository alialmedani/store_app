import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/classes/cashe_helper.dart';
import '../../home/screen/main_navigation_screen.dart';
import '../cubit/auth_cubit.dart';
import '../data/model/login_model.dart';
import 'register_screen_shadcn.dart';

/// Login Screen using shadcn_flutter components with clean architecture
/// Follows the CreateModel pattern from API_INTEGRATION_GUID.md
class LoginScreenShadcn extends StatefulWidget {
  const LoginScreenShadcn({super.key});

  @override
  State<LoginScreenShadcn> createState() => _LoginScreenShadcnState();
}

class _LoginScreenShadcnState extends State<LoginScreenShadcn> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.store,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Header
                Text(
                  'Store Management',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                const SizedBox(height: 48),

                // Form Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Username Field
                          TextField(
                            controller: _usernameController,
                            placeholder: const Text(
                              'Enter your username or email',
                            ),
                            onChanged: (value) {
                              context.read<AuthCubit>().loginParams.username =
                                  value;
                              if (_usernameError != null) {
                                setState(() {
                                  _usernameError = null;
                                });
                              }
                            },
                          ),
                          if (_usernameError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _usernameError!,
                                style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            placeholder: const Text('Enter your password'),
                            onChanged: (value) {
                              context.read<AuthCubit>().loginParams.password =
                                  value;
                              if (_passwordError != null) {
                                setState(() {
                                  _passwordError = null;
                                });
                              }
                            },
                          ),
                          if (_passwordError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _passwordError!,
                                style: const TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          const SizedBox(height: 24),

                          // Login Button - Using CreateModel for state management
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
                              // ✅ حفظ تاريخ انتهاء الصلاحية الفعلي
                              await CacheHelper.setDateWithExpiry(
                                loginModel.expiresIn ?? 3600,
                              );

                              // Fetch current user
                              final authCubit = context.read<AuthCubit>();
                              final userResult = await authCubit.getAppConfig();

                              if (userResult.hasDataOnly) {
                                authCubit.currentUser = userResult.data;

                                // Navigate to main navigation
                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainNavigationScreen(),
                                    ),
                                  );
                                }
                              } else {
                                // Show error
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                      'Failed to load user data. Please try again.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            onError: (error) {
                              // Show error message
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Login Failed'),
                                  content: Text('Error: $error'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: PrimaryButton(child: const Text('Sign In')),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreenShadcn(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
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
