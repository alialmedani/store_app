import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/auth_cubit.dart';
import '../data/model/register_model.dart';

/// Register Screen using shadcn_flutter components with clean architecture
/// Follows the CreateModel pattern from API_INTEGRATION_GUID.md
class RegisterScreenShadcn extends StatefulWidget {
  const RegisterScreenShadcn({super.key});

  @override
  State<RegisterScreenShadcn> createState() => _RegisterScreenShadcnState();
}

class _RegisterScreenShadcnState extends State<RegisterScreenShadcn> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      // Validate username
      if (_usernameController.text.isEmpty) {
        _usernameError = 'Please enter a username';
        isValid = false;
      } else if (_usernameController.text.length < 3) {
        _usernameError = 'Username must be at least 3 characters';
        isValid = false;
      } else {
        _usernameError = null;
      }

      // Validate email
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (_emailController.text.isEmpty) {
        _emailError = 'Please enter your email';
        isValid = false;
      } else if (!emailRegex.hasMatch(_emailController.text)) {
        _emailError = 'Please enter a valid email address';
        isValid = false;
      } else {
        _emailError = null;
      }

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'Please enter a password';
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        isValid = false;
      } else if (!RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
      ).hasMatch(_passwordController.text)) {
        _passwordError =
            'Password must contain uppercase, lowercase, number and special character';
        isValid = false;
      } else {
        _passwordError = null;
      }

      // Validate confirm password
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Please confirm your password';
        isValid = false;
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'Passwords do not match';
        isValid = false;
      } else {
        _confirmPasswordError = null;
      }
    });

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    density: ButtonDensity.compact,
                    variance: ButtonVariance.ghost,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Text(
                      'Join Store Management',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your account to get started',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    const SizedBox(height: 32),

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
                                placeholder: const Text('Choose a username'),
                                onChanged: (value) {
                                  context
                                          .read<AuthCubit>()
                                          .registerParams
                                          .userName =
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

                              // Email Field
                              TextField(
                                controller: _emailController,
                                placeholder: const Text('Enter your email'),
                                onChanged: (value) {
                                  context
                                          .read<AuthCubit>()
                                          .registerParams
                                          .emailAddress =
                                      value;
                                  if (_emailError != null) {
                                    setState(() {
                                      _emailError = null;
                                    });
                                  }
                                },
                              ),
                              if (_emailError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _emailError!,
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
                                placeholder: const Text(
                                  'Create a strong password',
                                ),
                                onChanged: (value) {
                                  context
                                          .read<AuthCubit>()
                                          .registerParams
                                          .password =
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
                              const SizedBox(height: 16),

                              // Password Requirements
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.info_outline, size: 16),
                                          SizedBox(width: 8),
                                          Text(
                                            'Password Requirements',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      _buildPasswordRequirement(
                                        'At least 6 characters',
                                      ),
                                      _buildPasswordRequirement(
                                        'One uppercase letter',
                                      ),
                                      _buildPasswordRequirement(
                                        'One lowercase letter',
                                      ),
                                      _buildPasswordRequirement('One number'),
                                      _buildPasswordRequirement(
                                        'One special character',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Confirm Password Field
                              TextField(
                                controller: _confirmPasswordController,
                                obscureText: _obscurePassword,
                                placeholder: const Text(
                                  'Re-enter your password',
                                ),
                                onChanged: (value) {
                                  if (_confirmPasswordError != null) {
                                    setState(() {
                                      _confirmPasswordError = null;
                                    });
                                  }
                                },
                              ),
                              if (_confirmPasswordError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    _confirmPasswordError!,
                                    style: const TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 24),

                              // Register Button - Using CreateModel for state management
                              CreateModel<RegisterModel>(
                                withValidation: true,
                                onTap: () {
                                  return _validateForm();
                                },
                                useCaseCallBack: (data) {
                                  return context.read<AuthCubit>().register();
                                },
                                onSuccess: (registerModel) {
                                  // Show success message
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Success'),
                                      content: const Text(
                                        'Registration successful! Please sign in.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                onError: (error) {
                                  // Show error message
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Registration Failed'),
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
                                child: PrimaryButton(
                                  child: const Text('Create Account'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign In',
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
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
