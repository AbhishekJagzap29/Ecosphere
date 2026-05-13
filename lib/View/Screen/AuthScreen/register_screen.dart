import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:echosphere/View/Constant/app_string.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/home_screen.dart';
import 'package:echosphere/View/Utils/app_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitRegister() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty && email.isEmpty && password.isEmpty) {
      errorSnackBar(
        AppString.requiredField,
        AppString.enterSignUpDetails,
      );
      return;
    }

    if (name.isEmpty) {
      errorSnackBar(
        AppString.requiredField,
        AppString.nameRequired,
      );
      return;
    }

    if (email.isEmpty) {
      errorSnackBar(
        AppString.requiredField,
        AppString.emailRequired,
      );
      return;
    }

    if (password.isEmpty) {
      errorSnackBar(
        AppString.requiredField,
        AppString.passwordRequired,
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              luxuryBlackColor,
              luxuryBlackAltColor,
              luxuryBlackColor,
            ],
            stops: [0, 0.52, 1],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  decoration: BoxDecoration(
                    color: premiumSurfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: premiumGoldBorderColor),
                    boxShadow: const [
                      BoxShadow(
                        color: premiumShadowColor,
                        blurRadius: 30,
                        offset: Offset(0, 18),
                      ),
                      BoxShadow(
                        color: premiumGoldShadowColor,
                        blurRadius: 34,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back_ios_new),
                          ),
                        ),
                        Image.asset(
                          'assets/images/logo.png',
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.eco,
                              size: 80,
                              color: greenMaterialColor,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          AppString.registerHeading,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: premiumTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AppString.registerSubheading,
                          style: TextStyle(
                            fontSize: 14,
                            color: premiumMutedTextColor,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: AppString.name,
                            hintText: AppString.enterName,
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: AppString.email,
                            hintText: AppString.emailHint,
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: AppString.password,
                            hintText: AppString.passwordHint,
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitRegister,
                            child: const Text(
                              AppString.signUp,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          AppString.alreadyHaveAccount,
                          style: TextStyle(
                            fontSize: 15,
                            color: premiumMutedTextColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            AppString.signIn,
                            style: TextStyle(
                              color: primaryGreenColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
