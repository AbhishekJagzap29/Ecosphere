import 'package:echosphere/View/Screen/AuthScreen/splash_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/about_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/home_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/profile.dart';
// import 'package:echosphere/View/Screen/BottomBarScreen/service_screen.dart';
import 'package:echosphere/View/Screen/Category/main_cat_screen.dart';
import 'package:get/get.dart';

class Routes {
  static String splashScreen = "/";
  static String homeScreen = "/homeScreen";

  static String serviceScreen = "/serviceScreen";
  static String profileScreen = "/profileScreen";
  static String aboutScreen = "/aboutScreen";

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: homeScreen,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: serviceScreen,
      page: () => const ServiceScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profileScreen,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: aboutScreen,
      page: () => const AboutScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
