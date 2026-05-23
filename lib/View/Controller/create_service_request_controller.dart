import 'dart:developer';
import 'package:dw_echosphere_app/Api/Repo/create_service_request_repo.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/create_service_request_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/shared_prefs.dart';
import 'package:dw_echosphere_app/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class CreateServiceRequestController extends GetxController {
  bool isLoading = false;

  Future<CreateServiceRequestResponseModel?> createServiceRequest({
    required String service,
    required String subservice,
    required String name,
    required String ownerId,
    required String address,
    required String phone,
    List<String> discounts = const [],
    String? youtubeLink,
    String? facebookLink,
    String? instagramLink,
    List<String> galleryImages = const [],
    List<String> facilities = const [],
  }) async {
    try {
      isLoading = true;
      update();

      final body = <String, dynamic>{
        'service': service.trim(),
        'subservice': subservice.trim(),
        'name': name.trim(),
        'owner_id': ownerId.trim(),
        'address': address.trim(),
        'phone': phone.trim(),
        'discounts': discounts,
        if (_hasText(youtubeLink)) 'youtube_link': youtubeLink!.trim(),
        if (_hasText(facebookLink)) 'facebook_link': facebookLink!.trim(),
        if (_hasText(instagramLink)) 'instagram_link': instagramLink!.trim(),
        'gallery_images': galleryImages
            .map((image) => image.trim())
            .where((image) => image.isNotEmpty)
            .toList(),
        'facilities': facilities
            .map((facility) => facility.trim())
            .where((facility) => facility.isNotEmpty)
            .toList(),
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
