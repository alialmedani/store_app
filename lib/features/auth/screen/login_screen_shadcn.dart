import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';
import 'package:store/core/ui/shadcn/design_system/app_design_tokens.dart';

import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/classes/cashe_helper.dart';
import '../../home/screen/main_navigation_screen.dart';
import '../cubit/auth_cubit.dart';
import '../data/model/login_model.dart';
import 'register_screen_shadcn.dart';
import 'package:easy_localization/easy_localization.dart';

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
        _usernameError = 'please_enter_your_username_or_email'.tr();
        isValid = false;
      } else {
        _usernameError = null;
      }

      // Validate password
      if (_passwordController.text.isEmpty) {
        _passwordError = 'please_enter_your_password'.tr();
        isValid = false;
      } else if (_passwordController.text.length < 6) {
        _passwordError = 'password_must_be_at_least_6_characters'.tr();
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
    final size = fw.MediaQuery.of(context).size;
    final heroHeight = size.height * 0.40;

    return Scaffold(
      child: fw.Stack(
        children: [
          // Ink hero (top ~40%): brand mark, serif app name, tagline.
          fw.Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: fw.Container(
              decoration: fw.BoxDecoration(
                color: AppDesignTokens.navBackgroundColor,
                gradient: fw.RadialGradient(
                  center: const fw.Alignment(0.0, -0.4),
                  radius: 1.0,
                  colors: [
                    AppDesignTokens.ember.withValues(alpha: 0.22),
                    AppDesignTokens.navBackgroundColor.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.75],
                ),
              ),
              child: fw.SafeArea(
                bottom: false,
                child: fw.Center(
                  child: fw.Column(
                    mainAxisSize: fw.MainAxisSize.min,
                    children: [
                      // Ember brand mark (matches the dashboard brand tile).
                      fw.Container(
                        width: 72,
                        height: 72,
                        alignment: fw.Alignment.center,
                        decoration: fw.BoxDecoration(
                          gradient: AppDesignTokens.primaryGradient,
                          borderRadius: fw.BorderRadius.circular(20),
                          boxShadow: AppDesignTokens.glowShadow,
                        ),
                        child: fw.Icon(
                          Icons.storefront_rounded,
                          size: 38,
                          color: AppDesignTokens.onAccentColor,
                        ),
                      ),
                      const fw.SizedBox(height: AppDesignTokens.sectionGap),
                      fw.Text(
                        'store_management'.tr(),
                        textAlign: fw.TextAlign.center,
                        style: fw.TextStyle(
                          fontFamily: AppDesignTokens.displayFontFamily,
                          fontFamilyFallback:
                              AppDesignTokens.displayFontFamilyFallback,
                          fontStyle: fw.FontStyle.italic,
                          fontSize: 32,
                          height: 1.1,
                          letterSpacing: AppDesignTokens.displayLetterSpacing,
                          color: AppDesignTokens.onAccentColor,
                        ),
                      ),
                      const fw.SizedBox(height: AppDesignTokens.smallGap),
                      fw.Text(
                        'login_tagline'.tr(),
                        textAlign: fw.TextAlign.center,
                        style: fw.TextStyle(
                          fontSize: AppDesignTokens.bodyFontSize,
                          fontWeight: AppDesignTokens.medium,
                          color: AppDesignTokens.navMutedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // White/dark sheet rising over the ink hero.
          fw.Positioned(
            top: heroHeight - 26,
            left: 0,
            right: 0,
            bottom: 0,
            child: fw.Container(
              decoration: fw.BoxDecoration(
                color: AppDesignTokens.backgroundColor,
                borderRadius: const fw.BorderRadius.only(
                  topLeft: fw.Radius.circular(26),
                  topRight: fw.Radius.circular(26),
                ),
              ),
              child: fw.SafeArea(
                top: false,
                child: fw.SingleChildScrollView(
                  padding: const fw.EdgeInsets.fromLTRB(24, 32, 24, 24),
                  child: fw.Center(
                    child: fw.Container(
                      constraints: const fw.BoxConstraints(maxWidth: 440),
                      child: fw.Form(
                        key: _formKey,
                        child: fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                          children: [
                            fw.Text(
                              'welcome_back'.tr(),
                              style: fw.TextStyle(
                                fontSize: AppDesignTokens.titleFontSize,
                                fontWeight: AppDesignTokens.bold,
                                letterSpacing:
                                    AppDesignTokens.titleLetterSpacing,
                                color: theme.colorScheme.foreground,
                              ),
                            ),
                            const fw.SizedBox(height: AppDesignTokens.smallGap),
                            fw.Text(
                              'welcome_back_sign_in_to_continue'.tr(),
                              style: fw.TextStyle(
                                fontSize: AppDesignTokens.bodyFontSize,
                                color: theme.colorScheme.mutedForeground,
                                fontWeight: AppDesignTokens.medium,
                              ),
                            ),
                            const fw.SizedBox(
                              height: AppDesignTokens.sectionGap + 8,
                            ),

                            // Username field
                            fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                fw.Text(
                                  'username_or_email'.tr(),
                                  style: fw.TextStyle(
                                    fontSize: AppDesignTokens.bodyFontSize,
                                    fontWeight: AppDesignTokens.semiBold,
                                    color: theme.colorScheme.foreground,
                                  ),
                                ),
                                const fw.SizedBox(height: 10),
                                TextField(
                                  controller: _usernameController,
                                  placeholder: Text(
                                    'enter_your_username_or_email'.tr(),
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
                                  _fieldError(theme, _usernameError!),
                              ],
                            ),
                            const fw.SizedBox(height: AppDesignTokens.cardGap),

                            // Password field
                            fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                fw.Row(
                                  mainAxisAlignment:
                                      fw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    fw.Text(
                                      'password'.tr(),
                                      style: fw.TextStyle(
                                        fontSize: AppDesignTokens.bodyFontSize,
                                        fontWeight: AppDesignTokens.semiBold,
                                        color: theme.colorScheme.foreground,
                                      ),
                                    ),
                                    fw.GestureDetector(
                                      onTap: () {
                                        // TODO: Implement forgot password
                                      },
                                      child: Text(
                                        'forgot_password'.tr(),
                                        style: fw.TextStyle(
                                          fontSize:
                                              AppDesignTokens.captionFontSize +
                                                  1,
                                          fontWeight: AppDesignTokens.semiBold,
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
                                      placeholder: Text(
                                        'enter_your_password'.tr(),
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
                                      padding:
                                          const fw.EdgeInsets.only(right: 12),
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
                                          color:
                                              theme.colorScheme.mutedForeground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_passwordError != null)
                                  _fieldError(theme, _passwordError!),
                              ],
                            ),
                            const fw.SizedBox(
                              height: AppDesignTokens.sectionGap + 4,
                            ),

                            // Login button (CreateModel-driven, Ember pill).
                            CreateModel<LoginModel>(
                              withValidation: true,
                              onTap: () {
                                return _validateFields();
                              },
                              useCaseCallBack: (data) {
                                return context.read<AuthCubit>().login();
                              },
                              onSuccess: (loginModel) async {
                                // Captured before async gaps.
                                final authCubit = context.read<AuthCubit>();
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

                                final userResult =
                                    await authCubit.getAppConfig();

                                if (userResult.hasDataOnly) {
                                  authCubit.currentUser = userResult.data;

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
                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('error_2'.tr()),
                                        content: Text(
                                          'failed_to_load_user_data_please_try_ag'
                                              .tr(),
                                        ),
                                        actions: [
                                          PrimaryButton(
                                            onPressed: () =>
                                                fw.Navigator.pop(ctx),
                                            child: Text('ok'.tr()),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              onError: (error) {
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
                                          Text('login_failed'.tr()),
                                        ],
                                      ),
                                      content:
                                          Text('error'.tr(args: ['$error'])),
                                      actions: [
                                        PrimaryButton(
                                          onPressed: () =>
                                              fw.Navigator.pop(ctx),
                                          child: Text('ok'.tr()),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: PrimaryButton(
                                child: fw.Row(
                                  mainAxisAlignment:
                                      fw.MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'sign_in'.tr(),
                                      style: const fw.TextStyle(
                                        fontSize: AppDesignTokens.cardTitleFontSize,
                                        fontWeight: AppDesignTokens.semiBold,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const fw.SizedBox(width: 8),
                                    Icon(
                                      RadixIcons.arrowRight,
                                      size: 18,
                                      color:
                                          theme.colorScheme.primaryForeground,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const fw.SizedBox(
                              height: AppDesignTokens.sectionGap + 4,
                            ),

                            // Register link
                            fw.Row(
                              mainAxisAlignment: fw.MainAxisAlignment.center,
                              children: [
                                fw.Text(
                                  'don_t_have_an_account'.tr(),
                                  style: fw.TextStyle(
                                    fontSize: AppDesignTokens.bodyFontSize,
                                    color: theme.colorScheme.mutedForeground,
                                    fontWeight: AppDesignTokens.medium,
                                  ),
                                ),
                                const fw.SizedBox(width: 6),
                                fw.GestureDetector(
                                  onTap: () {
                                    fw.Navigator.push(
                                      context,
                                      fw.PageRouteBuilder(
                                        pageBuilder: (_, __, ___) =>
                                            const RegisterScreenShadcn(),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'sign_up'.tr(),
                                    style: fw.TextStyle(
                                      fontSize: AppDesignTokens.bodyFontSize,
                                      color: theme.colorScheme.primary,
                                      fontWeight: AppDesignTokens.bold,
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fw.Widget _fieldError(ThemeData theme, String message) {
    return fw.Padding(
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
            message,
            style: fw.TextStyle(
              color: theme.colorScheme.destructive,
              fontSize: AppDesignTokens.captionFontSize + 1,
              fontWeight: AppDesignTokens.medium,
            ),
          ),
        ],
      ),
    );
  }
}
