import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Screen/Category/main_cat_screen.dart';
import 'package:flutter/material.dart';
import 'package:echosphere/View/Constant/app_string.dart';
import 'package:echosphere/View/Screen/AuthScreen/forget_password_screen.dart';
import 'package:echosphere/View/Screen/AuthScreen/register_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/home_screen.dart';
import 'package:echosphere/View/Controller/auth_controller.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _submitLogin() async {
    final login = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty && password.isEmpty) {
      errorSnackBar("Login Failed", "Please enter username and password");
      return;
    }

    if (login.isEmpty) {
      errorSnackBar("Login Failed", "Username is required");
      return;
    }

    if (password.isEmpty) {
      errorSnackBar("Login Failed", AppString.passwordRequired);
      return;
    }

    final response = await authController.userLogin(
      login: login,
      password: password,
    );

    if (!mounted) return;

    if (response?.status == "SUCCESS") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
        //     if (response?.status == "SUCCESS") {
        //   Navigator.of(context).pushReplacement(
        //     MaterialPageRoute(
        //       builder: (context) => const ServiceScreen(),
        //     ),
        //   );
        // }
  }

  @override
  void dispose() {
    _usernameController.dispose();
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
                        // Logo
                        Image.asset(
                          'assets/images/logo.png',
                          height: 82,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.eco,
                              size: 80,
                              color: greenMaterialColor,
                            );
                          },
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          AppString.welcomeBack,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: premiumTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          AppString.loginToAccount,
                          style: TextStyle(
                            fontSize: 14,
                            color: premiumMutedTextColor,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Username Field
                        TextField(
                          controller: _usernameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: AppString.username,
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _submitLogin(),
                          decoration: const InputDecoration(
                            labelText: AppString.password,
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              AppString.forgotPassword,
                              style: TextStyle(color: primaryGreenColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: GetBuilder<AuthController>(
                            builder: (controller) {
                              return ElevatedButton(
                                onPressed:
                                    controller.isLoading ? null : _submitLogin,
                                child: controller.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: blackColor,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        AppString.login,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                        ),
                                      ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          AppString.dontHaveAccount,
                          style: TextStyle(
                            fontSize: 15,
                            color: premiumMutedTextColor,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            AppString.signUp,
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
