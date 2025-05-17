import 'package:shortly_customer/features/Onboarding/screens/fetching_location_screen.dart';
import 'package:shortly_customer/features/Onboarding/screens/login_screen.dart';
import 'package:shortly_customer/features/Onboarding/screens/otp_verification_screen.dart';
import 'package:shortly_customer/features/Onboarding/screens/splash_screen.dart';
import 'package:shortly_customer/features/cart/screen/booking_page.dart';
import 'package:shortly_customer/features/cart/screen/cart_screen.dart';
import 'package:shortly_customer/features/cart/screen/search_provider.dart';
import 'package:shortly_customer/features/home/screens/home_screen.dart';
import 'package:shortly_customer/features/home/screens/sub_sub_service_screen.dart';
import 'package:shortly_customer/features/home/screens/subservice_screen.dart';
import 'package:shortly_customer/features/orders/screens/orders_details_screen.dart';
import 'package:shortly_customer/features/profile/screens/edit_profile_screen.dart';
import 'package:shortly_customer/nav_bar.dart';

import '../core/app_imports.dart';
import 'app_pages.dart';

final kNavigatorKey = GlobalKey<NavigatorState>();

class CustomNavigator {
  static Route<dynamic> controller(RouteSettings settings) {
    //use settings.arguments to pass arguments in pages
    switch (settings.name) {
      case AppPages.appEntry:
        return MaterialPageRoute(
          builder: (context) => SplashScreen(),
          settings: settings,
        );

      case AppPages.login:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
          settings: settings,
        );
      case AppPages.otpverification:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => OtpVerificationPage(
            phoneNumber: args["phoneNumber"] ?? '',
          ),
          settings: settings,
        );

      case AppPages.fetchinglocation:
        return MaterialPageRoute(
          builder: (context) => FetchingLocationScreen(),
          settings: settings,
        );
      case AppPages.navbar:
        return MaterialPageRoute(
          builder: (context) => NavBarScreen(),
          settings: settings,
        );
      case AppPages.home:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
          settings: settings,
        );

      case AppPages.cart:
        return MaterialPageRoute(
          builder: (context) => CartPage(),
          settings: settings,
        );

      case AppPages.bookingpage:
        return MaterialPageRoute(
          builder: (context) => BookingPage(),
          settings: settings,
        );
      case AppPages.providerFindingpage:
        return MaterialPageRoute(
          builder: (context) => ProviderFindingPage(),
          settings: settings,
        );
      // case AppPages.subservices:
      //   return MaterialPageRoute(
      //     builder: (context) => SubServiceScreen(),
      //     settings: settings,
      //   );

      case AppPages.editprofilescreen:
        return MaterialPageRoute(
          builder: (context) => EditProfilePage(),
          settings: settings,
        );

      case AppPages.ordersdetailspage:
        return MaterialPageRoute(
          builder: (context) => OrderDetailsPage(),
          settings: settings,
        );
      case AppPages.subsubservices:
        return MaterialPageRoute(
          builder: (context) => SubSubServiceScreen(),
          settings: settings,
        );
      default:
        throw ('This route name does not exit');
    }
  }

  // Pushes to the route specified
  static Future<T?> pushTo<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.of(context, rootNavigator: true)
        .pushNamed(strPageName, arguments: arguments);
  }

  // Pop the top view
  static void pop(BuildContext context, {Object? result}) {
    Navigator.pop(context, result);
  }

  // Pops to a particular view
  static Future<T?> popTo<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.popAndPushNamed(
      context,
      strPageName,
      arguments: arguments,
    );
  }

  static void popUntilFirst(BuildContext context) {
    Navigator.popUntil(context, (page) => page.isFirst);
  }

  static void popUntilRoute(BuildContext context, String route, {var result}) {
    Navigator.popUntil(context, (page) {
      if (page.settings.name == route && page.settings.arguments != null) {
        (page.settings.arguments as Map<String, dynamic>)["result"] = result;
        return true;
      }
      return false;
    });
  }

  static Future<T?> pushReplace<T extends Object?>(
    BuildContext context,
    String strPageName, {
    Object? arguments,
  }) async {
    return await Navigator.pushReplacementNamed(
      context,
      strPageName,
      arguments: arguments,
    );
  }
}
