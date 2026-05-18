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
    int? talukaId,
  }) async {
    try {
      isLoading = true;
      serviceDetails = [];
      update();

      final response = await ServiceDetailRepo().serviceDetailListRepo(
        subserviceId: subserviceId,
        talukaId: talukaId,
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
