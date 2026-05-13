import 'dart:developer';

import 'package:echosphere/Api/Repo/taluka_repo.dart';
import 'package:echosphere/Api/ResponseModel/taluka_response_model.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class TalukaController extends GetxController {
  bool isLoading = false;
  String? errorMessage;
  List<TalukaData> talukas = [];

  Future<void> getTalukas() async {
    try {
      isLoading = true;
      errorMessage = null;
      update();

      final response = await TalukaRepo().talukaListRepo();

      if (response.status?.toLowerCase() == 'success') {
        talukas = response.data
            .where((taluka) => taluka.name != null && taluka.name!.isNotEmpty)
            .toList();
      } else {
        talukas = [];
        errorMessage = response.message ?? 'Unable to load talukas';
        errorSnackBar('Talukas Failed', errorMessage!);
      }
    } catch (e) {
      log('Taluka Error >>> $e');
      talukas = [];
      errorMessage = e.toString();
      errorSnackBar('Error', errorMessage!);
    } finally {
      isLoading = false;
      update();
    }
  }
}