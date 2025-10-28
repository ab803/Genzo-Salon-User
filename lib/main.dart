import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:userbarber/Feature/Auth/AuthRepo.dart';
import 'package:userbarber/Feature/Auth/Manager/auth_cubit.dart';
import 'package:userbarber/Feature/Booking/Repo/bookingRepo.dart';
import 'package:userbarber/Feature/Booking/ViewModel/booking__cubit.dart';
import 'package:userbarber/Feature/Booking/ViewModel/service__cubit.dart';
import 'package:userbarber/Feature/Booking/repo/ServiceRepo.dart';
import 'package:userbarber/Feature/Cart/ViewModel/order_cubit.dart';
import 'package:userbarber/Feature/Cart/orderRepo/orderRepo.dart';
import 'package:userbarber/Feature/Localization/Locales.dart';
import 'package:userbarber/Feature/ValueNotifier.dart';
import 'package:userbarber/core/Styles/Styles.dart';
import 'package:userbarber/core/Utilities/app_router.dart';
import 'package:userbarber/core/Utilities/getit.dart';
import 'package:userbarber/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await loadTheme();

  // ✅ Required for flutter_localization
  await FlutterLocalization.instance.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    configureLocalization();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<OrderCubit>(
              create: (context) =>
                  OrderCubit(getIt<OrderRepository>())
                    ..loadOrders(FirebaseAuth.instance.currentUser!.uid),
            ),
            BlocProvider<BookingCubit>(
              create: (_) => BookingCubit(bookingRepo: BookingRepo()),
            ),
            BlocProvider<ServiceCubit>(
              create: (_) => ServiceCubit(getIt<ServiceRepo>())..loadServices(),
            ),
            BlocProvider(
              create: (_) => AuthCubit(AuthRepository())..autoSignIn(),
            ),
          ],
          child: MaterialApp.router(
            locale: localization.currentLocale ?? DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            routerConfig: router,

            // ✅ Localization setup
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,

            // ✅ Theme setup
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: AppColors.lightBackground,
              cardColor: AppColors.lightCard,
              primaryColor: AppColors.primaryNavy,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: AppColors.lightText),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: AppColors.darkBackground,
              cardColor: AppColors.darkCard,
              primaryColor: AppColors.primaryNavy,
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: AppColors.darkText),
              ),
            ),
            themeMode: mode,
          ),
        );
      },
    );
  }

  /// Initialize localization
  void configureLocalization() {
    localization.init(mapLocales: locales, initLanguageCode: 'en');
    localization.onTranslatedLanguage = (locale) => setState(() {});
  }
}
