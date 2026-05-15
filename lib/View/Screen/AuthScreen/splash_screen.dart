import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';
import 'package:echosphere/View/Screen/AuthScreen/user_registration_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _openNextScreen();
  }

  Future<void> _openNextScreen() async {
    final minimumSplashTime = Future.delayed(const Duration(seconds: 3));

    try {
      await preferences.init().timeout(const Duration(seconds: 5));
    } catch (_) {
      // Continue with default registration flow if preferences are unavailable.
    }

    await minimumSplashTime;

    if (!mounted) return;

    final isUserRegistered = preferences.getBool(
          SharedPreference.isUserRegistered,
        ) ??
        false;

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isUserRegistered == true
            ? const HomeScreen()
            : const UserRegistrationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: luxuryBlackColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.72,
            colors: [
              Color(0x331A1A1A),
              luxuryBlackColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: premiumGoldShadowColor,
                      blurRadius: 46,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 220,
                  height: 220,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.eco,
                      size: 132,
                      color: goldPrimaryColor,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'ECHOSPHERE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: whiteColor,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Apno ke Liye...',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: goldHighlightColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
