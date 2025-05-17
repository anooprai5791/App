import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/constants/app_themes.dart';
import 'package:shortly_customer/core/constants/value_constants.dart';
import 'package:shortly_customer/core/managers/app_manager.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/features/Onboarding/screens/splash_screen.dart';
import 'package:shortly_customer/features/cart/data/booking_provider.dart';
import 'package:shortly_customer/features/cart/data/cart_provider.dart';
import 'package:shortly_customer/features/home/data/home_screen_provider.dart';
import 'package:shortly_customer/features/home/data/select_provider_provider.dart';
import 'package:shortly_customer/features/home/data/sub_service_pprovider.dart';
import 'package:shortly_customer/features/profile/data/edit_profile_provider.dart';
import 'package:shortly_customer/route/custom_navigator.dart';

import 'core/loaded_widget.dart';

String lang = "";
Position? currentPosition;
String currentAddress = "Fetching location...";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppManager.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => SelectProviderScreenProvider()),
        ChangeNotifierProvider(create: (_) => SubServiceDetailsProvider('')),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: ScreenUtilInit(
          designSize:
              const Size(VALUE_FIGMA_DESIGN_WIDTH, VALUE_FIGMA_DESIGN_HEIGHT),
          builder: () => MaterialApp(
                // locale: value.appLocale,
                // localizationsDelegates: const [
                //   AppLocalizations.delegate,
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                // ],
                // supportedLocales: const [Locale('en'), Locale('hi')],
                debugShowCheckedModeBanner: false,
                title: 'Shorty - Customer',
                initialRoute: '/',
                onGenerateRoute: CustomNavigator.controller,
                themeMode: ThemeMode.light,
                builder: OverlayManager.transitionBuilder(),
                theme: AppThemes.light,
                home: SplashScreen(),
              )),
    );
  }
}
