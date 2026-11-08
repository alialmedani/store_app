import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/auth_cubit.dart';
import '../data/model/register_model.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

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
        _usernameError = 'please_enter_a_username'.tr();
        isValid = false;
      } else if (_usernameController.text.length < 3) {
        _usernameError = 'username_must_be_at_least_3_characters'.tr();
        isValid = false;
      } else {
        _usernameError = null;
      }

      // Validate email
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (_emailController.text.isEmpty) {
        _emailError = 'please_enter_your_email'.tr();
        isValid = false;
      } else if (!emailRegex.hasMatch(_emailController.text)) {
        _emailError = 'please_enter_a_valid_email_address'.tr();
        isValid = false;
      } else {
        _emailError = null;
      }

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'please_enter_a_password'.tr();
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'password_must_be_at_least_6_characters'.tr();
        isValid = false;
      } else if (!RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]',
      ).hasMatch(_passwordController.text)) {
        _passwordError =
            'password_must_contain_uppercase_lowerc'.tr();
        isValid = false;
      } else {
        _passwordError = null;
      }

      // Validate confirm password
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'please_confirm_your_password'.tr();
        isValid = false;
      } else if (_confirmPasswordController.text != _passwordController.text) {
        _confirmPasswordError = 'passwords_do_not_match'.tr();
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
        child: ScrollAwayHeader(header: Column(children: [
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
                  Text(
                    'create_account'.tr(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )]), body: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    Text(
                      'join_store_management'.tr(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'create_your_account_to_get_started'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppDesignTokens.mutedTextColor,
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
                                placeholder: Text('choose_a_username'.tr()),
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
                                    style: TextStyle(
                                      color: AppDesignTokens.dangerColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),

                              // Email Field
                              TextField(
                                controller: _emailController,
                                placeholder: Text('enter_your_email'.tr()),
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
                                    style: TextStyle(
                                      color: AppDesignTokens.dangerColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),

                              // Password Field
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                placeholder: Text(
                                  'create_a_strong_password'.tr(),
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
                                    style: TextStyle(
                                      color: AppDesignTokens.dangerColor,
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
                                            'password_requirements'.tr(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      _buildPasswordRequirement(
                                        'at_least_6_characters'.tr(),
                                      ),
                                      _buildPasswordRequirement(
                                        'one_uppercase_letter'.tr(),
                                      ),
                                      _buildPasswordRequirement(
                                        'one_lowercase_letter'.tr(),
                                      ),
                                      _buildPasswordRequirement('one_number'.tr()),
                                      _buildPasswordRequirement(
                                        'one_special_character'.tr(),
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
                                placeholder: Text(
                                  're_enter_your_password'.tr(),
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
                                    style: TextStyle(
                                      color: AppDesignTokens.dangerColor,
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
                                      title: Text('success'.tr()),
                                      content: Text(
                                        'registration_successful_please_sign_in'.tr(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            Navigator.pop(context);
                                          },
                                          child: Text('ok'.tr()),
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
                                      title: Text('registration_failed'.tr()),
                                      content: Text('error'.tr(args: ['${error}'])),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: Text('ok'.tr()),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: PrimaryButton(
                                  child: Text('create_account'.tr()),
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
                          'already_have_an_account'.tr(),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppDesignTokens.mutedTextColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'sign_in'.tr(),
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
              )),
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
