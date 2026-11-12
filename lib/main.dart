import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:store/core/classes/cashe_helper.dart';
import 'package:store/features/auth/screen/auth_wrapper.dart';
import 'package:store/features/inventory/cubit/inventory_cubit.dart';
import 'package:store/features/order/cubit/order_cubit.dart';
import 'package:store/features/reports/cubit/reports_cubit.dart';
import 'package:store/features/product/cubit/product_cubit.dart';

import 'core/classes/keys.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/category/cubit/category_cubit.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/product_variant/cubit/product_variant_cubit.dart';
import 'core/ui/shadcn/design_system/app_pro_theme.dart';
import 'core/ui/shadcn/design_system/theme_controller.dart';
import 'core/ui/shadcn/design_system/app_design_tokens.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await EasyLocalization.ensureInitialized();
  await ThemeController.instance.load();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FireBaseNotification().initNotification();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en'), Locale('bn')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      useOnlyLangCode: true,
      saveLocale: true,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with fw.WidgetsBindingObserver {
  final ThemeController _theme = ThemeController.instance;

  @override
  void initState() {
    super.initState();
    fw.WidgetsBinding.instance.addObserver(this);
    _theme.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _theme.removeListener(_onThemeChanged);
    fw.WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_theme.mode == AppThemeMode.system) _onThemeChanged();
  }

  void _onThemeChanged() {
    if (!mounted) return;
    _theme.apply(fw.WidgetsBinding.instance.platformDispatcher.platformBrightness);
    setState(() {});
    // Design tokens are plain getters, so widgets that do not depend on the
    // Theme must be rebuilt explicitly (state and navigation are preserved).
    fw.WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      void rebuild(fw.Element el) {
        el.markNeedsBuild();
        el.visitChildren(rebuild);
      }

      (context as fw.Element).visitChildren(rebuild);
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme.apply(fw.WidgetsBinding.instance.platformDispatcher.platformBrightness);
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
        BlocProvider<ProductCubit>(create: (context) => ProductCubit()),
        BlocProvider<ProductVariantCubit>(
          create: (context) => ProductVariantCubit(),
        ),
        BlocProvider<OrderCubit>(create: (context) => OrderCubit()),
        BlocProvider<InventoryCubit>(create: (context) => InventoryCubit()),
        BlocProvider<ReportsCubit>(create: (context) => ReportsCubit()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: false,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: Keys.navigatorKey,
            title: 'Store Management',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            themeMode: AppDesignTokens.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AppProTheme.light,
            darkTheme: AppProTheme.dark,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
