
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/constant/app_colors/app_colors.dart';
import 'dart:ui';
import '../../classes/cashe_helper.dart';
import '../../classes/notification.dart';
import '../../utils/Navigation/navigation.dart';

class SplashSscreen extends StatefulWidget {
  const SplashSscreen({super.key});

  @override
  State<SplashSscreen> createState() => _SplashSscreenState();
}

class _SplashSscreenState extends State<SplashSscreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _timerController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _timerAnimation;

  int _countdown = 3;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkUserAuthentication();
  }

  void _checkUserAuthentication() async {
    _startAnimations();

    bool shouldNavigateToRoot = false;
    bool shouldNavigateToOfficeboy = false;

    // try {
    //   final result = await context.read<ProfileCubit>().fetchCurrentCustomer();

    //   if (result.hasDataOnly) {
    //     if (result.data?.roles?.contains('User') == true) {
    //       CacheHelper.setRole('User');
    //       await FireBaseNotification().updateTopicSubscriptions();
    //       shouldNavigateToRoot = true;
    //     } else {
    //       await FireBaseNotification().updateTopicSubscriptions();
    //       shouldNavigateToOfficeboy = true;
    //     }
    //     CacheHelper.setFloor(result.data?.floorId);
    //     CacheHelper.setOffice(result.data?.officeId);
    //   }
    // } catch (e) {
    //   debugPrint('Error fetching user data: $e');
    // }
    await Future.delayed(const Duration(seconds: 3));

    // Navigate based on API result
    // if (mounted) {
    //   if (shouldNavigateToRoot) {
    //     Navigation.pushAndRemoveUntil(const RootScreen());
    //   } else if (shouldNavigateToOfficeboy) {
    //     Navigation.pushAndRemoveUntil(const OfficeBoyOrdersScreen());
    //   } else {
    //     _navigateToLogin();
    //   }
    // }
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _timerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _timerController, curve: Curves.linear));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _fadeController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      _scaleController.forward();
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      _startTimer();
    });
  }

  void _startTimer() {
    _timerController.forward();

    for (int i = 1; i <= 3; i++) {
      Future.delayed(Duration(seconds: i), () {
        if (mounted) {
          setState(() {
            _countdown = 3 - i;
          });
        }
      });
    }
  }

  // void _navigateToLogin() {
  //   Navigator.pushReplacement(
  //     context,
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation, secondaryAnimation) =>
  //           // const LoginScreen(),
  //       // transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       //   return FadeTransition(
  //       //     opacity: animation,
  //       //     child: SlideTransition(
  //       //       position: Tween<Offset>(
  //       //         begin: const Offset(1.0, 0.0),
  //       //         end: Offset.zero,
  //       //       ).animate(animation),
  //       //       child: child,
  //       //     ),
  //       //   );
  //       // },
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black87,
              Colors.black.withValues(alpha: 0.7),
              AppColors.xprimaryColor.withValues(alpha: 0.2),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    "assets/images/bg.png",
                    height: size.height,
                    width: size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            Positioned(
              top: size.height * 0.15,
              right: size.width * 0.1,
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value * 0.6,
                    child: Opacity(
                      opacity: 0.3,
                      child: Image.asset(
                        "assets/images/bean1.png",
                        width: 60,
                        height: 60,
                      ),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  height: size.height * 0.55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black,
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.xprimaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        AppColors.xprimaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: AppColors.xprimaryColor.withValues(
                                        alpha: 0.5,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                    width: 60,
                                    height: 60,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withValues(alpha: 0.9),
                                      AppColors.xprimaryColor.withValues(
                                        alpha: 0.8,
                                      ),
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    "Fall in Love with\nCoffee in Blissful\nDelight!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 28,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      height: 1.1,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: Text(
                                  "Welcome to our cozy coffee corner, where every cup is a delightful experience crafted just for you.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              ScaleTransition(
                                scale: _scaleAnimation,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                                width: 3,
                                              ),
                                            ),
                                          ),
                                          AnimatedBuilder(
                                            animation: _timerAnimation,
                                            builder: (context, child) {
                                              return CircularProgressIndicator(
                                                value: _timerAnimation.value,
                                                strokeWidth: 4,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(AppColors.xprimaryColor),
                                                backgroundColor:
                                                    Colors.transparent,
                                              );
                                            },
                                          ),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 300,
                                            ),
                                            child: Text(
                                              '$_countdown',
                                              key: ValueKey(_countdown),
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.xprimaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
      ),
    );
  }
}