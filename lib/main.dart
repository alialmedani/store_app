import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:store/core/classes/cashe_helper.dart';
import 'package:store/features/auth/screen/auth_wrapper.dart';
import 'package:store/features/order/cubit/order_cubit.dart'; 
import 'package:store/features/product/cubit/product_cubit.dart';

import 'core/classes/keys.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/category/cubit/category_cubit.dart';
import 'features/product_variant/cubit/product_variant_cubit.dart';

SharedPreferences? prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await EasyLocalization.ensureInitialized();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<CategoryCubit>(create: (context) => CategoryCubit()),
        BlocProvider<ProductCubit>(create: (context) => ProductCubit()),
        BlocProvider<ProductVariantCubit>(
          create: (context) => ProductVariantCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (context) => OrderCubit(),
        ),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: false,
        builder: (BuildContext context, Widget? child) {
          return ShadcnApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: Keys.navigatorKey,
            title: 'Store Management',
            themeMode: ThemeMode.light,
            theme: ThemeData(colorScheme: ColorSchemes.lightZinc, radius: 0.5),
            darkTheme: ThemeData(
              colorScheme: ColorSchemes.darkZinc,
              radius: 0.5,
            ),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}
