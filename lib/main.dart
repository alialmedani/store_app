import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/core/classes/cashe_helper.dart';
import 'package:store/features/home/cubit/home_cubit.dart';
import 'package:store/features/store/categories/cubit/categories_cubit.dart';
import 'package:store/features/store/create_product/cubit/create_product_cubit.dart';
import 'package:store/features/store/lookups/cubit/lookups_cubit.dart';
import 'package:store/features/store/product_details/cubit/product_details_cubit.dart';
import 'package:store/features/store/root/cubit/store_root_cubit.dart';
import 'package:store/features/store/root/screen/store_root_screen.dart';
import 'core/classes/keys.dart';
import 'core/constant/app_theme/app_theme.dart';

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
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(create: (context) => ProductDetailsCubit()),
        BlocProvider(create: (context) => CreateProductCubit()),
        BlocProvider(create: (context) => LookupsCubit()),
        BlocProvider(create: (context) => StoreRootCubit()),
        BlocProvider(create: (context) => CategoriesCubit()),
        // BlocProvider(create: (context) => RootCubit()),
        // BlocProvider(create: (context) => ProfileCubit()),
        // BlocProvider(create: (context) => OfficeBoyCubit()),
        // BlocProvider(create: (context) => AuthCubit()),
        // BlocProvider(create: (context) => DrinkCubit()),
        // BlocProvider(create: (context) => CartCubit()),
        // BlocProvider(create: (context) => OrderCubit()),
        // BlocProvider(create: (context) => PlaceCubit()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        splitScreenMode: false,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            debugShowCheckedModeBanner: false,
            navigatorKey: Keys.navigatorKey,
            title: 'Task App',
            theme: appThemeData[AppTheme.light],
            home: const StoreRootScreen(),
          );
        },
      ),
    );
  }
}
