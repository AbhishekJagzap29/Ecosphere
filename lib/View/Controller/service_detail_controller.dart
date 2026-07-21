import 'dart:developer';

import 'package:dw_echosphere_app/Api/Repo/service_detail_repo.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/service_detail_response_model.dart';
import 'package:dw_echosphere_app/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class ServiceDetailController extends GetxController {
  bool isLoading = false;
  List<ServiceDetailData> serviceDetails = [];
  final Map<String, List<ServiceDetailData>> _cache = {};

  Future<void> getServiceDetails({
    int? subserviceId,
    int? talukaId,
  }) async {
    final cacheKey = "${subserviceId}_${talukaId ?? 0}";

    // Return cached data instantly if it exists
    if (_cache.containsKey(cacheKey)) {
      serviceDetails = _cache[cacheKey]!;
      update();
      return;
    }

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
        _cache[cacheKey] = response.data;
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

  void clearCacheKey({int? subserviceId, int? talukaId}) {
    final cacheKey = "${subserviceId}_${talukaId ?? 0}";
    _cache.remove(cacheKey);
  }

  void clearAllCache() {
    _cache.clear();
  }
}
