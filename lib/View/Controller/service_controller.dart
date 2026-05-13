import 'dart:developer';

import 'package:echosphere/Api/Repo/service_repo.dart';
import 'package:echosphere/Api/ResponseModel/service_response_model.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class ServiceController extends GetxController {
  bool isLoading = false;
  bool isHomeLoading = false;
  String? homeErrorMessage;
  List<ServiceData> services = [];
  List<ServiceData> popularServices = [];
  List<ServiceData> exploreServices = [];

  Future<void> getServices() async {
    try {
      isLoading = true;
      update();

      final response = await ServiceRepo().serviceListRepo();

      if (response.status?.toLowerCase() == 'success') {
        services = response.data;
      } else {
        services = [];
        errorSnackBar(
          'Services Failed',
          response.message ?? 'Unable to load services',
        );
      }
    } catch (e) {
      log('Service Error >>> $e');
      services = [];
      errorSnackBar('Error', e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> getHomeServices() async {
    try {
      isHomeLoading = true;
      homeErrorMessage = null;
      update();

      final repo = ServiceRepo();
      final popularResponse = await repo.popularServiceListRepo();
      ServiceResponseModel? otherResponse;

      try {
        otherResponse = await repo.otherServiceListRepo();
      } catch (e) {
        log('Explore Services Error >>> $e');
      }

      if (popularResponse.status?.toLowerCase() != 'success') {
        popularServices = [];
        exploreServices = [];
        homeErrorMessage =
            popularResponse.message ?? 'Unable to load popular services';
        return;
      }

      popularServices = popularResponse.data;
      exploreServices = otherResponse?.data ?? [];

      log(
        'Home services images >>> popular: '
        '${popularServices.where((service) => service.image != null).length}/'
        '${popularServices.length}, explore: '
        '${exploreServices.where((service) => service.image != null).length}/'
        '${exploreServices.length}',
      );
    } catch (e) {
      log('Popular Services Error >>> $e');
      popularServices = [];
      exploreServices = [];
      homeErrorMessage = e.toString();
    } finally {
      isHomeLoading = false;
      update();
    }
  }
}
