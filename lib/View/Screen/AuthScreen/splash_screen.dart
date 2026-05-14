import 'dart:async';
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
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      final isUserRegistered = preferences.getBool(
        SharedPreference.isUserRegistered,
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => isUserRegistered == true
              ? const HomeScreen()
              : const UserRegistrationScreen(),
        ),
      );
    });
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