
import 'dart:convert';
import 'dart:developer';

import 'package:echosphere/Api/Repo/auth_repo.dart';
import 'package:echosphere/Api/ResponseModel/login_response_model.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  bool isLoading = false;

  Future<LoginResponseModel?> userLogin({
    required String login,
    required String password,
  }) async {
    try {
      isLoading = true;
      update();

      Map<String, dynamic> body = {
        "jsonrpc": "2.0",
        "params": {
          "db": ApiRouts.databaseName,
          "login": login,
          "password": password,
        },
      };

      log("Login Body >>> $body");

      LoginResponseModel response =
          await AuthRepo().loginRepo(body: body);

      log("Login Response >>> ${response.toJson()}");

      if (response.status == "SUCCESS") {
        await preferences.putBool(SharedPreference.isLogin, true);
        await preferences.putString(SharedPreference.userType, "user");

        await preferences.putString(
          SharedPreference.userLoginData,
          jsonEncode(response.toJson()),
        );

        await preferences.putString(
          SharedPreference.userId,
          response.userId.toString(),
        );

        await preferences.putString(
          SharedPreference.userName,
          response.login ?? "",
        );

        await preferences.putString(
          SharedPreference.sessionId,
          response.sessionId ??
              preferences.getString(SharedPreference.sessionId) ??
              "",
        );

        successSnackBar("Success", response.message ?? "Login successful");
      } else {
        final message = response.message?.trim().toLowerCase() == "access denied"
            ? "Invalid Credentials"
            : response.message ?? "Invalid Credentials";
        errorSnackBar("Login Failed", message);
      }

      return response;
    } catch (e) {
      log("Login Error >>> $e");
      errorSnackBar("Error", e.toString());
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }
}
