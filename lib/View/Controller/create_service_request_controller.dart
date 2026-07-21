import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:dw_echosphere_app/Api/Repo/create_service_request_repo.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/create_service_request_response_model.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/service_response_model.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/sub_service_response_model.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/taluka_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/shared_prefs.dart';
import 'package:dw_echosphere_app/View/Utils/app_layout.dart';

class SelectedGalleryImage {
  final Uint8List bytes;
  final String base64;
  final String name;

  const SelectedGalleryImage({
    required this.bytes,
    required this.base64,
    required this.name,
  });
}

class CreateServiceRequestController extends GetxController {
  // Form Controllers
  final serviceTextController = TextEditingController();
  final subserviceTextController = TextEditingController();
  final talukaTextController = TextEditingController();
  final nameController = TextEditingController();
  final ownerIdController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final discountController = TextEditingController();
  final youtubeLinkController = TextEditingController();
  final facebookLinkController = TextEditingController();
  final instagramLinkController = TextEditingController();
  final facilitiesController = TextEditingController();

  // Focus Nodes
  final serviceFocusNode = FocusNode();
  final subserviceFocusNode = FocusNode();
  final talukaFocusNode = FocusNode();

  // Selected State
  ServiceData? selectedService;
  SubServiceData? selectedSubService;
  TalukaData? selectedTaluka;
  final List<SelectedGalleryImage> selectedGalleryImages = [];

  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    serviceTextController.addListener(_syncSelectedService);
    subserviceTextController.addListener(_syncSelectedSubService);
    talukaTextController.addListener(_syncSelectedTaluka);
  }

  @override
  void onClose() {
    serviceTextController.removeListener(_syncSelectedService);
    subserviceTextController.removeListener(_syncSelectedSubService);
    talukaTextController.removeListener(_syncSelectedTaluka);
    
    serviceTextController.dispose();
    subserviceTextController.dispose();
    talukaTextController.dispose();
    nameController.dispose();
    ownerIdController.dispose();
    addressController.dispose();
    phoneController.dispose();
    discountController.dispose();
    youtubeLinkController.dispose();
    facebookLinkController.dispose();
    instagramLinkController.dispose();
    facilitiesController.dispose();
    
    serviceFocusNode.dispose();
    subserviceFocusNode.dispose();
    talukaFocusNode.dispose();
    
    super.onClose();
  }

  void _syncSelectedService() {
    final selectedName = selectedService?.name?.trim();
    final currentName = serviceTextController.text.trim();

    if (selectedService != null && selectedName != currentName) {
      selectedService = null;
      selectedSubService = null;
      subserviceTextController.clear();
      update();
    }
  }

  void _syncSelectedSubService() {
    final selectedName = selectedSubService?.name?.trim();
    final currentName = subserviceTextController.text.trim();

    if (selectedSubService != null && selectedName != currentName) {
      selectedSubService = null;
      update();
    }
  }

  void _syncSelectedTaluka() {
    final selectedName = selectedTaluka?.name?.trim();
    final currentName = talukaTextController.text.trim();

    if (selectedTaluka != null && selectedName != currentName) {
      selectedTaluka = null;
      update();
    }
  }

  // Setters/State Helpers
  void setSelectedService(ServiceData service) {
    selectedService = service;
    selectedSubService = null;
    subserviceTextController.clear();
    serviceTextController.text = service.name ?? 'Service ${service.id}';
    update();
  }

  void setSelectedSubService(SubServiceData subService) {
    selectedSubService = subService;
    subserviceTextController.text = subService.name ?? 'Sub Service ${subService.id}';
    update();
  }

  void setSelectedTaluka(TalukaData taluka) {
    selectedTaluka = taluka;
    talukaTextController.text = taluka.name ?? 'Taluka ${taluka.id}';
    update();
  }

  // Image Picking
  Future<void> pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(source: source);
      if (image == null) return;

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        image.path,
        quality: 75,
        minWidth: 1200,
        minHeight: 1200,
      );

      final bytes = compressedBytes ?? await image.readAsBytes();
      selectedGalleryImages.add(
        SelectedGalleryImage(
          bytes: bytes,
          base64: base64Encode(bytes),
          name: image.name,
        ),
      );
      update();
    } catch (e) {
      errorSnackBar('Image Failed', e.toString());
    }
  }

  Future<void> pickGalleryImages() async {
    try {
      final images = await _imagePicker.pickMultiImage();
      if (images.isEmpty) return;

      final selectedImages = await Future.wait(
        images.map((image) async {
          final compressedBytes = await FlutterImageCompress.compressWithFile(
            image.path,
            quality: 75,
            minWidth: 1200,
            minHeight: 1200,
          );
          final bytes = compressedBytes ?? await image.readAsBytes();
          return SelectedGalleryImage(
            bytes: bytes,
            base64: base64Encode(bytes),
            name: image.name,
          );
        }),
      );

      selectedGalleryImages.addAll(selectedImages);
      update();
    } catch (e) {
      errorSnackBar('Image Failed', e.toString());
    }
  }

  void removeSelectedImage(int index) {
    selectedGalleryImages.removeAt(index);
    update();
  }

  void clearSelectedImages() {
    selectedGalleryImages.clear();
    update();
  }

  List<String> _parseFacilities() {
    return facilitiesController.text
        .split(',')
        .map((facility) => facility.trim())
        .where((facility) => facility.isNotEmpty)
        .toList();
  }

  List<String> _parseDiscounts() {
    return discountController.text
        .split(',')
        .map((discount) => discount.trim())
        .where((discount) => discount.isNotEmpty)
        .toList();
  }

  Future<CreateServiceRequestResponseModel?> submitRequest() async {
    try {
      isLoading = true;
      update();

      final body = <String, dynamic>{
        'service': serviceTextController.text.trim(),
        'subservice': subserviceTextController.text.trim(),
        'name': nameController.text.trim(),
        'owner_id': ownerIdController.text.trim(),
        'address': addressController.text.trim(),
        'phone': phoneController.text.trim(),
        if (selectedTaluka != null) 'taluka_id': selectedTaluka!.id,
        'discounts': _parseDiscounts(),
        if (_hasText(youtubeLinkController.text)) 'youtube_link': youtubeLinkController.text.trim(),
        if (_hasText(facebookLinkController.text)) 'facebook_link': facebookLinkController.text.trim(),
        if (_hasText(instagramLinkController.text)) 'instagram_link': instagramLinkController.text.trim(),
        'gallery_images': selectedGalleryImages
            .map((image) => image.base64.trim())
            .where((image) => image.isNotEmpty)
            .toList(),
        'facilities': _parseFacilities()
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
