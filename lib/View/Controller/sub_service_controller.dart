import 'dart:developer';
import 'package:echosphere/Api/Repo/sub_service_repo.dart';
import 'package:echosphere/Api/ResponseModel/sub_service_response_model.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class SubServiceController extends GetxController {
  bool isLoading = false;
  List<SubServiceData> subServices = [];
  int _requestSerial = 0;

  Future<void> getSubServices({
    int? serviceId,
  }) async {
    final requestSerial = ++_requestSerial;

    bool isCurrentRequest() => requestSerial == _requestSerial;
    try {

      isLoading = true;
      subServices = [];
      update();

      final response = await SubServiceRepo().subServiceListRepo(
        serviceId: serviceId,
      );
      
      if (!isCurrentRequest()) return;
      if (response.status?.toLowerCase() == 'success') {
        subServices = response.data;
      } else {
        subServices = [];
        errorSnackBar(
          'Sub Services Failed',
          response.message ?? 'Unable to load sub services',
        );
      }
    } catch (e) {
      if (!isCurrentRequest()) return;
      log('Sub Service Error >>> $e');
      subServices = [];
      errorSnackBar('Error', e.toString());
    } finally {
      if (!isCurrentRequest()) return;
      isLoading = false;
      update();
    }
  }
}
