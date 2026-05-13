import 'dart:developer';

import 'package:echosphere/Api/Repo/customer_registration_repo.dart';
import 'package:echosphere/Api/ResponseModel/customer_registration_response_model.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class CustomerRegistrationController extends GetxController {
  bool isLoading = false;

  Future<CustomerRegistrationResponseModel?> registerCustomer({
    required String name,
    required String phone,
    required int talukaId,
    bool isCardHolder = false,
  }) async {
    try {
      isLoading = true;
      update();

      final response = await CustomerRegistrationRepo().registerCustomer(
        name: name,
        phone: phone,
        talukaId: talukaId,
        isCardHolder: isCardHolder,
      );

      if (response.status?.toLowerCase() != 'success') {
        errorSnackBar(
          'Registration Failed',
          response.message ?? 'Unable to register customer',
        );
        return response;
      }

      successSnackBar(
        'Registration Complete',
        response.message ?? 'Customer registered successfully',
      );
      return response;
    } catch (e) {
      log('Customer Registration Error >>> $e');
      errorSnackBar('Error', e.toString());
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }
}