import 'package:dw_echosphere_app/View/Controller/executive_auth_controller.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Screen/Category/executive_main_cat_screen.dart';
import 'package:dw_echosphere_app/View/Utils/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExcecutiveScreen extends StatefulWidget {
  const ExcecutiveScreen({super.key});

  @override
  State<ExcecutiveScreen> createState() => _ExcecutiveScreenState();
}

class _ExcecutiveScreenState extends State<ExcecutiveScreen> {
  final ExecutiveAuthController _authController =
      Get.put(ExecutiveAuthController());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Executive Area',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: whiteColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: goldPrimaryColor),
          onPressed: () => Navigator.maybePop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [luxuryBlackColor, luxuryBlackAltColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Stack(
          children: [
            // Ambient Glow Spots
            const Positioned(
              top: 40,
              right: -80,
              child: _ExecutiveLoginGlowSpot(size: 200, opacity: 0.08),
            ),
            const Positioned(
              bottom: 60,
              left: -80,
              child: _ExecutiveLoginGlowSpot(size: 220, opacity: 0.06),
            ),
            Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Container(
                    padding: const EdgeInsets.all(30),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 82,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.eco,
                                size: 80,
                                color: goldPrimaryColor,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Center(
                          child: Text(
                            "EXECUTIVE LOGIN",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: premiumTextColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            "Access your dashboard and requests",
                            style: TextStyle(
                              fontSize: 13,
                              color: premiumMutedTextColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Username
                        _ExecutiveTextField(
                          controller: _usernameController,
                          labelText: 'Username',
                          icon: Icons.person_outline_rounded,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 18),

                        // Password
                        _ExecutiveTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _login(),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IconButton(
                              splashRadius: 22,
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: goldPrimaryColor.withOpacity(0.08),
                                  border: Border.all(
                                    color: goldPrimaryColor.withOpacity(0.25),
                                  ),
                                ),
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  size: 18,
                                  color: goldPrimaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Login Action Button
                        SizedBox(
                          height: 52,
                          child: GetBuilder<ExecutiveAuthController>(
                            builder: (controller) {
                              return ElevatedButton(
                                onPressed: controller.isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: goldPrimaryColor,
                                  foregroundColor: luxuryBlackColor,
                                  disabledBackgroundColor: premiumBorderColor,
                                  disabledForegroundColor: premiumMutedTextColor,
                                  elevation: 4,
                                  shadowColor: goldPrimaryColor.withOpacity(0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: controller.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: luxuryBlackColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    final login = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty && password.isEmpty) {
      errorSnackBar('Login Failed', 'Please enter username and password');
      return;
    }

    if (login.isEmpty) {
      errorSnackBar('Login Failed', 'Username is required');
      return;
    }

    if (password.isEmpty) {
      errorSnackBar('Login Failed', 'Password is required');
      return;
    }

    final response = await _authController.login(
      login: login,
      password: password,
    );

    if (!mounted) return;

    if (response?.isSuccess == true) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ExecutiveServiceScreen(),
        ),
      );
    }
  }
}

class _ExecutiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? suffixIcon;

  const _ExecutiveTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        color: premiumTextColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: goldPrimaryColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: premiumMutedTextColor),
        prefixIcon: Icon(icon, color: goldPrimaryColor),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: premiumSurfaceColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: premiumGoldBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: goldPrimaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: redColor),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: redColor),
        ),
      ),
    );
  }
}

class _ExecutiveLoginGlowSpot extends StatelessWidget {
  final double size;
  final double opacity;

  const _ExecutiveLoginGlowSpot({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: goldPrimaryColor.withOpacity(opacity),
      ),
    );
  }
}
