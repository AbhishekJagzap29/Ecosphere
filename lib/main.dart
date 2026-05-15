import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:echosphere/View/Screen/AuthScreen/splash_screen.dart';
import 'package:echosphere/View/Utils/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Echosphere',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: goldPrimaryColor,
          brightness: Brightness.dark,
          surface: premiumSurfaceColor,
        ),
        scaffoldBackgroundColor: premiumScaffoldColor,
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.dark().textTheme,
        ).apply(
          bodyColor: premiumTextColor,
          displayColor: premiumTextColor,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          backgroundColor: luxuryBlackColor,
          foregroundColor: goldPrimaryColor,
          iconTheme: const IconThemeData(color: goldPrimaryColor),
          titleTextStyle: GoogleFonts.poppins(
            color: whiteColor,
            fontSize: 19,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
        cardTheme: CardTheme(
          color: premiumSurfaceColor,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: premiumBorderColor),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: premiumSurfaceTintColor,
          prefixIconColor: premiumMutedTextColor,
          hintStyle: const TextStyle(color: premiumMutedTextColor),
          labelStyle: const TextStyle(color: premiumMutedTextColor),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: premiumBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: premiumBorderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: goldPrimaryColor,
              width: 1.6,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: goldPrimaryColor,
            foregroundColor: blackColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              letterSpacing: 0,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: goldPrimaryColor,
            side: const BorderSide(color: premiumGoldBorderColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      getPages: Routes.routes,
      home: const SplashScreen(),
    );
  }
}
