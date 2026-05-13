import 'dart:developer';

import 'package:echosphere/Api/Repo/create_service_request_repo.dart';
import 'package:echosphere/Api/ResponseModel/create_service_request_response_model.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class CreateServiceRequestController extends GetxController {
  bool isLoading = false;

  Future<CreateServiceRequestResponseModel?> createServiceRequest({
    required String service,
    required String subservice,
    required String name,
    required String address,
    required String phone,
    String? discount,
    String? image,
  }) async {
    try {
      isLoading = true;
      update();

      final body = <String, dynamic>{
        'service': service.trim(),
        'subservice': subservice.trim(),
        'name': name.trim(),
        'address': address.trim(),
        'phone': phone.trim(),
        if (_hasText(discount)) 'discount': discount!.trim(),
        if (_hasText(image)) 'image': image!.trim(),
      };

      final response = await CreateServiceRequestRepo().create(body: body);

      if (response.isSuccess) {
        successSnackBar(
          'Success',
          response.message ?? 'Request Submitted Successfully',
        );
      } else {
        errorSnackBar(
          'Request Failed',
          response.message ?? 'Unable to create service request',
        );
      }

      return response;
    } catch (e) {
      log('Create Service Request Error >>> $e');
      errorSnackBar('Error', e.toString());
      return null;
    } finally {
      isLoading = false;
      update();
    }
  }

  bool _hasText(String? value) => value != null && value.trim().isNotEmpty;
}
