import 'dart:developer';

import 'package:echosphere/Api/Repo/service_detail_repo.dart';
import 'package:echosphere/Api/ResponseModel/service_detail_response_model.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class ServiceDetailController extends GetxController {
  bool isLoading = false;
  List<ServiceDetailData> serviceDetails = [];

  Future<void> getServiceDetails({
    int? subserviceId,
  }) async {
    try {
      isLoading = true;
      serviceDetails = [];
      update();

      final response = await ServiceDetailRepo().serviceDetailListRepo(
        subserviceId: subserviceId,
      );

      if (response.status?.toLowerCase() == 'success') {
        serviceDetails = response.data;
      } else {
        serviceDetails = [];
        errorSnackBar(
          'Service Details Failed',
          response.message ?? 'Unable to load service details',
        );
      }
    } catch (e) {
      log('Service Detail Error >>> $e');
      serviceDetails = [];
      errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}
