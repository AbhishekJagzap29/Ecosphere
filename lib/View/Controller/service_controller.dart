import 'dart:developer';

import 'package:dw_echosphere_app/Api/Repo/service_repo.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/service_response_model.dart';
import 'package:dw_echosphere_app/View/Utils/app_layout.dart';
import 'package:get/get.dart';

class HomeCategory {
  final int? id;
  final String name;
  final String? image;

  const HomeCategory({
    this.id,
    required this.name,
    this.image,
  });
}

class ServiceController extends GetxController {
  bool isLoading = false;
  bool isHomeLoading = false;
  String? homeErrorMessage;
  List<ServiceData> services = [];
  List<ServiceData> popularServices = [];
  List<ServiceData> exploreServices = [];

  List<HomeCategory> get popularHomeCategories =>
      _buildHomeCategories(popularServices);
  List<HomeCategory> get exploreHomeCategories =>
      _buildHomeCategories(exploreServices);

  static List<HomeCategory> _buildHomeCategories(List<ServiceData> services) {
    final categories = <HomeCategory>[];
    final usedIds = <int>{};
    final usedNames = <String>{};

    for (final service in services) {
      final name = service.name?.trim();
      if (name == null || name.isEmpty) continue;

      final serviceId = service.id;
      final normalizedName =
          name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
      if (serviceId != null && !usedIds.add(serviceId)) continue;
      if (serviceId == null && !usedNames.add(normalizedName)) continue;

      categories.add(
        HomeCategory(
          id: serviceId,
          name: name,
          image: service.image,
        ),
      );
    }

    return categories;
  }

  Future<void> getServices({
    int? talukaId,
  }) async {
    try {
      isLoading = true;
      update();

      final response = await ServiceRepo().serviceListRepo(
        talukaId: talukaId,
      );

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
