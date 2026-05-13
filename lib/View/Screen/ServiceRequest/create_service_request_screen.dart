import 'dart:convert';
import 'dart:typed_data';

import 'package:echosphere/Api/ResponseModel/service_response_model.dart';
import 'package:echosphere/Api/ResponseModel/sub_service_response_model.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Controller/create_service_request_controller.dart';
import 'package:echosphere/View/Controller/service_controller.dart';
import 'package:echosphere/View/Controller/sub_service_controller.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateServiceRequestScreen extends StatefulWidget {
  const CreateServiceRequestScreen({super.key});

  @override
  State<CreateServiceRequestScreen> createState() =>
      _CreateServiceRequestScreenState();
}

class _CreateServiceRequestScreenState
    extends State<CreateServiceRequestScreen> {
  final CreateServiceRequestController _requestController =
      Get.put(CreateServiceRequestController());
  final ServiceController _serviceController =
      Get.isRegistered<ServiceController>()
          ? Get.find<ServiceController>()
          : Get.put(ServiceController());
  final SubServiceController _subServiceController =
      Get.isRegistered<SubServiceController>()
          ? Get.find<SubServiceController>()
          : Get.put(SubServiceController());

  final TextEditingController _serviceTextController = TextEditingController();
  final TextEditingController _subserviceTextController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final FocusNode _serviceFocusNode = FocusNode();
  final FocusNode _subserviceFocusNode = FocusNode();

  final ImagePicker _imagePicker = ImagePicker();
  ServiceData? _selectedService;
  SubServiceData? _selectedSubService;
  Uint8List? _selectedImageBytes;
  String? _selectedImageBase64;
  String? _selectedImageName;

  @override
  void initState() {
    super.initState();
    _serviceTextController.addListener(_syncSelectedService);
    _subserviceTextController.addListener(_syncSelectedSubService);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_serviceController.services.isEmpty) {
        _serviceController.getServices();
      }
    });
  }

  @override
  void dispose() {
    _serviceTextController.removeListener(_syncSelectedService);
    _subserviceTextController.removeListener(_syncSelectedSubService);
    _serviceTextController.dispose();
    _subserviceTextController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _discountController.dispose();
    _serviceFocusNode.dispose();
    _subserviceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      appBar: AppBar(
        title: const Text('Create Request'),
        backgroundColor: premiumScaffoldColor,
        foregroundColor: whiteColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GetBuilder<ServiceController>(
                builder: (controller) {
                  return _AutocompleteTextField<ServiceData>(
                    controller: _serviceTextController,
                    focusNode: _serviceFocusNode,
                    labelText: 'Service',
                    icon: Icons.category_outlined,
                    options: controller.services,
                    enabled: !controller.isLoading,
                    displayStringForOption: (service) =>
                        service.name ?? 'Service ${service.id}',
                    onSelected: (service) {
                      final serviceName =
                          service.name ?? 'Service ${service.id}';
                      setState(() {
                        _selectedService = service;
                        _selectedSubService = null;
                        _subserviceTextController.clear();
                      });
                      _serviceTextController.text = serviceName;
                      _subServiceController.getSubServices(
                        serviceId: service.id,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 14),
              GetBuilder<SubServiceController>(
                builder: (controller) {
                  return _AutocompleteTextField<SubServiceData>(
                    controller: _subserviceTextController,
                    focusNode: _subserviceFocusNode,
                    labelText: 'Sub Service',
                    icon: Icons.list_alt_outlined,
                    options: controller.subServices,
                    enabled: !controller.isLoading,
                    displayStringForOption: (subService) =>
                        subService.name ?? 'Sub Service ${subService.id}',
                    onSelected: (subService) {
                      final subServiceName =
                          subService.name ?? 'Sub Service ${subService.id}';
                      setState(() {
                        _selectedSubService = subService;
                      });
                      _subserviceTextController.text = subServiceName;
                    },
                  );
                },
              ),
              const SizedBox(height: 14),
              _RequestTextField(
                controller: _nameController,
                labelText: 'Name',
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _RequestTextField(
                controller: _addressController,
                labelText: 'Address',
                icon: Icons.location_on_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              _RequestTextField(
                controller: _phoneController,
                labelText: 'Phone',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _RequestTextField(
                controller: _discountController,
                labelText: 'Discount',
                icon: Icons.percent_outlined,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 14),
              _ImagePickerField(
                imageBytes: _selectedImageBytes,
                imageName: _selectedImageName,
                onTap: _showImageSourcePicker,
                onClear: _clearSelectedImage,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: GetBuilder<CreateServiceRequestController>(
                  builder: (controller) {
                    return ElevatedButton(
                      onPressed: controller.isLoading ? null : _createRequest,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldPrimaryColor,
                        foregroundColor: luxuryBlackColor,
                        disabledBackgroundColor: premiumBorderColor,
                        disabledForegroundColor: premiumMutedTextColor,
                      ),
                      child: controller.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: luxuryBlackColor,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Create',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createRequest() async {
    FocusScope.of(context).unfocus();

    final serviceName = _serviceTextController.text.trim();
    final subserviceName = _subserviceTextController.text.trim();
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    final phone = _phoneController.text.trim();

    if (serviceName.isEmpty) {
      errorSnackBar('Request Failed', 'Please select or enter service');
      return;
    }

    if (subserviceName.isEmpty) {
      errorSnackBar('Request Failed', 'Please select or enter sub service');
      return;
    }

    if (name.isEmpty) {
      errorSnackBar('Request Failed', 'Name is required');
      return;
    }

    if (address.isEmpty) {
      errorSnackBar('Request Failed', 'Address is required');
      return;
    }

    if (phone.isEmpty) {
      errorSnackBar('Request Failed', 'Phone is required');
      return;
    }

    final response = await _requestController.createServiceRequest(
      service: serviceName,
      subservice: subserviceName,
      name: name,
      address: address,
      phone: phone,
      discount: _discountController.text,
      image: _selectedImageBase64,
    );

    if (!mounted) return;

    if (response?.isSuccess == true) {
      Navigator.of(context).pop(true);
    }
  }

  void _syncSelectedService() {
    final selectedName = _selectedService?.name?.trim();
    final currentName = _serviceTextController.text.trim();

    if (_selectedService != null && selectedName != currentName) {
      setState(() {
        _selectedService = null;
        _selectedSubService = null;
        _subserviceTextController.clear();
      });
    }
  }

  void _syncSelectedSubService() {
    final selectedName = _selectedSubService?.name?.trim();
    final currentName = _subserviceTextController.text.trim();

    if (_selectedSubService != null && selectedName != currentName) {
      setState(() {
        _selectedSubService = null;
      });
    }
  }

  Future<void> _showImageSourcePicker() async {
    FocusScope.of(context).unfocus();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: premiumSurfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera_outlined,
                    color: goldPrimaryColor,
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(color: premiumTextColor),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: goldPrimaryColor,
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(color: premiumTextColor),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 75,
        maxWidth: 1200,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();
      if (!mounted) return;

      setState(() {
        _selectedImageBytes = bytes;
        _selectedImageBase64 = base64Encode(bytes);
        _selectedImageName = image.name;
      });
    } catch (e) {
      errorSnackBar('Image Failed', e.toString());
    }
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImageBase64 = null;
      _selectedImageName = null;
    });
  }
}

class _AutocompleteTextField<T extends Object> extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final IconData icon;
  final List<T> options;
  final bool enabled;
  final String Function(T option) displayStringForOption;
  final ValueChanged<T> onSelected;

  const _AutocompleteTextField({
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.icon,
    required this.options,
    required this.displayStringForOption,
    required this.onSelected,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<T>(
      textEditingController: controller,
      focusNode: focusNode,
      displayStringForOption: displayStringForOption,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) return options;

        return options.where((option) {
          return displayStringForOption(option).toLowerCase().contains(query);
        });
      },
      onSelected: onSelected,
      fieldViewBuilder: (
        context,
        textEditingController,
        fieldFocusNode,
        onFieldSubmitted,
      ) {
        return TextField(
          controller: textEditingController,
          focusNode: fieldFocusNode,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: premiumTextColor),
          cursorColor: goldPrimaryColor,
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(icon, color: goldPrimaryColor),
            suffixIcon: const Icon(
              Icons.arrow_drop_down_rounded,
              color: goldPrimaryColor,
            ),
            filled: true,
            fillColor: premiumSurfaceTintColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: premiumGoldBorderColor),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: premiumGoldBorderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: goldPrimaryColor),
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onOptionSelected, filteredOptions) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: premiumSurfaceColor,
            elevation: 8,
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220, maxWidth: 360),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final option = filteredOptions.elementAt(index);

                  return InkWell(
                    onTap: () => onOptionSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Text(
                        displayStringForOption(option),
                        style: const TextStyle(color: premiumTextColor),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ImagePickerField extends StatelessWidget {
  final Uint8List? imageBytes;
  final String? imageName;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _ImagePickerField({
    required this.imageBytes,
    required this.imageName,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageBytes != null;

    return Material(
      color: transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            minHeight: hasImage ? 112 : 58,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: premiumSurfaceTintColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: premiumGoldBorderColor),
          ),
          child: Row(
            children: [
              Container(
                width: hasImage ? 88 : 34,
                height: hasImage ? 88 : 34,
                decoration: BoxDecoration(
                  color: premiumSurfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: premiumGoldBorderColor),
                ),
                clipBehavior: Clip.antiAlias,
                child: hasImage
                    ? Image.memory(imageBytes!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.image_outlined,
                        color: goldPrimaryColor,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasImage ? 'Image selected' : 'Upload Image',
                      style: const TextStyle(
                        color: premiumTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasImage
                          ? imageName ?? 'Tap to change image'
                          : 'Choose from camera or gallery',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: premiumMutedTextColor),
                    ),
                  ],
                ),
              ),
              if (hasImage)
                IconButton(
                  tooltip: 'Remove image',
                  onPressed: onClear,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: premiumMutedTextColor,
                  ),
                )
              else
                const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: goldPrimaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;

  const _RequestTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      style: const TextStyle(color: premiumTextColor),
      cursorColor: goldPrimaryColor,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: goldPrimaryColor),
        filled: true,
        fillColor: premiumSurfaceTintColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: premiumGoldBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: goldPrimaryColor),
        ),
      ),
    );
  }
}
