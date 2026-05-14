import 'dart:developer';

import 'package:echosphere/Api/Repo/create_service_request_repo.dart';
import 'package:echosphere/Api/ResponseModel/create_service_request_response_model.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';
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
    String? youtubeLink,
    String? facebookLink,
    String? instagramLink,
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
        if (_hasText(youtubeLink)) 'youtube_link': youtubeLink!.trim(),
        if (_hasText(facebookLink)) 'facebook_link': facebookLink!.trim(),
        if (_hasText(instagramLink)) 'instagram_link': instagramLink!.trim(),
        if (_hasText(image)) 'image': image!.trim(),
        if (_executiveUserId != null) 'user_id': _executiveUserId,
        if (_executiveUserId != null) 'executive_user_id': _executiveUserId,
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

  int? get _executiveUserId {
    final userType = preferences.getString(SharedPreference.userType);
    if (userType != 'executive') return null;

    final userId = preferences.getString(SharedPreference.userId);
    return int.tryParse(userId ?? '');
  }
}
