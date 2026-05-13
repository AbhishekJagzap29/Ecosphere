import 'package:echosphere/View/Controller/executive_auth_controller.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Screen/Category/main_cat_screen.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      appBar: AppBar(
        title: const Text('Executive'),
        backgroundColor: premiumScaffoldColor,
        foregroundColor: whiteColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 28, 18, 28),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: premiumSurfaceColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: premiumGoldBorderColor),
              boxShadow: const [
                BoxShadow(
                  color: premiumShadowColor,
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.eco,
                        size: 112,
                        color: goldPrimaryColor,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 26),
                _ExecutiveTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  icon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),
                _ExecutiveTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _login(),
                ),
                const SizedBox(height: 24),
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
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
                                  fontWeight: FontWeight.w800,
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

    // final response = await _authController.login(
    await _authController.login(


      login: login,
      password: password,
    );

    // if (!mounted) return;

    // if (response?.isSuccess == true) {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => const ServiceScreen(),
    //     ),
    //   );
    // }
  }
}

class _ExecutiveTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  const _ExecutiveTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.obscureText = false,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      style: const TextStyle(color: premiumTextColor),
      cursorColor: goldPrimaryColor,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: premiumMutedTextColor),
        prefixIcon: Icon(icon, color: goldPrimaryColor),
        filled: true,
        fillColor: premiumSurfaceTintColor,
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
