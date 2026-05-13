import 'dart:developer';

import 'package:echosphere/Api/Repo/executive_auth_repo.dart';
import 'package:echosphere/Api/ResponseModel/executive_login_response_model.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class ExecutiveAuthController extends GetxController {
  bool isLoading = false;

  Future<ExecutiveLoginResponseModel?> login({
    required String login,
    required String password,
  }) async {
    try {
      isLoading = true;
      update();

      final response = await ExecutiveAuthRepo().login(
        login: login,
        password: password,
      );

      if (response.isSuccess) {
        successSnackBar('Success', response.message ?? 'Login successful');
      } else {
        final message = response.message?.trim().toLowerCase() == 'access denied'
            ? 'Invalid Credentials'
            : response.message ?? 'Invalid Credentials';
        errorSnackBar('Login Failed', message);
      }

      return response;
    } catch (e) {
      log('Executive Login Error >>> $e');
      errorSnackBar('Error', e.toString());
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }
}
