import 'package:dw_echosphere_app/Api/ResponseModel/service_response_model.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/sub_service_response_model.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/taluka_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Controller/create_service_request_controller.dart';
import 'package:dw_echosphere_app/View/Controller/service_controller.dart';
import 'package:dw_echosphere_app/View/Controller/sub_service_controller.dart';
import 'package:dw_echosphere_app/View/Controller/taluka_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

// Spacing constants
const gap14 = SizedBox(height: 14);
const gap24 = SizedBox(height: 24);

class CreateServiceRequestScreen extends StatefulWidget {
  const CreateServiceRequestScreen({super.key});

  @override
  State<CreateServiceRequestScreen> createState() =>
      _CreateServiceRequestScreenState();
}

class _CreateServiceRequestScreenState
    extends State<CreateServiceRequestScreen> {
  final _formKey = GlobalKey<FormState>();

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
  final TalukaController _talukaController =
      Get.isRegistered<TalukaController>()
          ? Get.find<TalukaController>()
          : Get.put(TalukaController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_serviceController.services.isEmpty) {
        _serviceController.getServices();
      }
      if (_talukaController.talukas.isEmpty) {
        _talukaController.getTalukas();
      }
    });
  }

  String? _validateUrl(String? value, String label) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    if (uri == null || !uri.isAbsolute) {
      return 'Enter a valid URL for $label';
    }
    return null;
  }

  Future<void> _createRequest() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final response = await _requestController.submitRequest();

    if (!mounted) return;

    if (response?.isSuccess == true) {
      Navigator.of(context).pop(true);
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
                    _requestController.pickImage(ImageSource.camera);
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
                    _requestController.pickGalleryImages();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
          child: GetBuilder<CreateServiceRequestController>(
            builder: (requestCtrl) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Service Details Group
                    const _FormSectionHeader(title: "Service Details"),
                    
                    GetBuilder<ServiceController>(
                      builder: (controller) {
                        return _AutocompleteTextField<ServiceData>(
                          controller: requestCtrl.serviceTextController,
                          focusNode: requestCtrl.serviceFocusNode,
                          labelText: 'Service',
                          icon: Icons.category_outlined,
                          options: controller.services,
                          enabled: !controller.isLoading,
                          displayStringForOption: (service) =>
                              service.name ?? 'Service ${service.id}',
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Service selection is required';
                            }
                            return null;
                          },
                          onSelected: (service) {
                            requestCtrl.setSelectedService(service);
                            _subServiceController.getSubServices(
                              serviceId: service.id,
                            );
                          },
                        );
                      },
                    ),
                    gap14,
                    GetBuilder<SubServiceController>(
                      builder: (controller) {
                        return _AutocompleteTextField<SubServiceData>(
                          controller: requestCtrl.subserviceTextController,
                          focusNode: requestCtrl.subserviceFocusNode,
                          labelText: 'Sub Service',
                          icon: Icons.list_alt_outlined,
                          options: controller.subServices,
                          enabled: !controller.isLoading,
                          displayStringForOption: (subService) =>
                              subService.name ?? 'Sub Service ${subService.id}',
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Sub Service selection is required';
                            }
                            return null;
                          },
                          onSelected: (subService) {
                            requestCtrl.setSelectedSubService(subService);
                          },
                        );
                      },
                    ),

                    // 2. Business Details Group
                    const _FormSectionHeader(title: "Business Details"),
                    
                    _RequestTextField(
                      controller: requestCtrl.nameController,
                      labelText: 'Name',
                      icon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Business name is required';
                        }
                        return null;
                      },
                    ),
                    gap14,
                    _RequestTextField(
                      controller: requestCtrl.ownerIdController,
                      labelText: 'Owner',
                      icon: Icons.badge_outlined,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Owner is required';
                        }
                        return null;
                      },
                    ),
                    gap14,
                    _RequestTextField(
                      controller: requestCtrl.phoneController,
                      labelText: 'Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Phone number is required';
                        }
                        if (val.trim().length < 10) {
                          return 'Phone must be exactly 10 digits';
                        }
                        return null;
                      },
                    ),
                    gap14,
                    GetBuilder<TalukaController>(
                      builder: (controller) {
                        return DropdownSearch<TalukaData>(
                          enabled: !controller.isLoading,
                          selectedItem: requestCtrl.selectedTaluka,
                          items: controller.talukas,
                          itemAsString: (taluka) => taluka.name ?? '',
                          compareFn: (item, selectedItem) => item.id == selectedItem.id,
                          onChanged: (taluka) {
                            if (taluka != null) {
                              requestCtrl.setSelectedTaluka(taluka);
                            }
                          },
                          dropdownButtonProps: const DropdownButtonProps(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: goldPrimaryColor,
                            ),
                          ),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: 'Taluka',
                              prefixIcon: const Icon(Icons.location_on_outlined, color: goldPrimaryColor),
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
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: premiumBorderColor),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.redAccent),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
                              ),
                            ),
                            baseStyle: const TextStyle(
                              color: premiumTextColor,
                            ),
                          ),
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            showSelectedItems: true,
                            searchDelay: Duration.zero,
                            menuProps: const MenuProps(
                              backgroundColor: premiumSurfaceTintColor,
                            ),
                            searchFieldProps: const TextFieldProps(
                              style: TextStyle(color: premiumTextColor),
                              cursorColor: goldPrimaryColor,
                              decoration: InputDecoration(
                                hintText: 'Search taluka',
                                hintStyle: TextStyle(color: premiumMutedTextColor),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: goldPrimaryColor,
                                ),
                                filled: true,
                                fillColor: premiumSurfaceColor,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: premiumGoldBorderColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: goldPrimaryColor),
                                ),
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                dense: true,
                                selected: isSelected,
                                selectedTileColor: premiumSurfaceColor,
                                title: Text(
                                  item.name ?? '',
                                  style: const TextStyle(color: premiumTextColor),
                                ),
                              );
                            },
                          ),
                          validator: (val) {
                            if (val == null) {
                              return 'Taluka selection is required';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    gap14,
                    _RequestTextField(
                      controller: requestCtrl.addressController,
                      labelText: 'Address',
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),

                    // 3. Offers & Facilities Group
                    const _FormSectionHeader(title: "Offers & Facilities"),
                    
                    _RequestTextField(
                      controller: requestCtrl.facilitiesController,
                      labelText: 'Facilities (comma separated)',
                      icon: Icons.check_circle_outline,
                      textInputAction: TextInputAction.next,
                    ),
                    gap14,
                    _RequestTextField(
                      controller: requestCtrl.discountController,
                      labelText: 'Discount / Offers (comma separated)',
                      icon: Icons.percent_outlined,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                    ),

                    // 4. Social Links Group
                    const _FormSectionHeader(title: "Social Links"),
                    
                    _RequestTextField(
                      controller: requestCtrl.youtubeLinkController,
                      labelText: 'YouTube Link',
                      icon: Icons.play_circle_outline,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      validator: (val) => _validateUrl(val, 'YouTube Link'),
                    ),
                    gap14,
                    _RequestTextField(
                      controller: requestCtrl.facebookLinkController,
                      labelText: 'Facebook Link',
                      icon: Icons.facebook,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      validator: (val) => _validateUrl(val, 'Facebook Link'),
                    ),
                    gap14,
                    _RequestTextField(
                      controller: requestCtrl.instagramLinkController,
                      labelText: 'Instagram Link',
                      icon: Icons.camera_alt_outlined,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      validator: (val) => _validateUrl(val, 'Instagram Link'),
                    ),

                    // 5. Gallery Group
                    const _FormSectionHeader(title: "Gallery"),
                    
                    _ImagePickerField(
                      images: requestCtrl.selectedGalleryImages,
                      onTap: _showImageSourcePicker,
                      onClearImage: requestCtrl.removeSelectedImage,
                      onClearAll: requestCtrl.clearSelectedImages,
                    ),
                    gap24,
                    
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: requestCtrl.isLoading ? null : _createRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: goldPrimaryColor,
                          foregroundColor: luxuryBlackColor,
                          disabledBackgroundColor: premiumBorderColor,
                          disabledForegroundColor: premiumMutedTextColor,
                        ),
                        child: requestCtrl.isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: luxuryBlackColor,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    'Creating...',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              )
                            : const Text(
                                'Create Request',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FormSectionHeader extends StatelessWidget {
  final String title;
  const _FormSectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: goldPrimaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(color: premiumBorderColor, height: 1),
        ],
      ),
    );
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
  final FormFieldValidator<String>? validator;

  const _AutocompleteTextField({
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.icon,
    required this.options,
    required this.displayStringForOption,
    required this.onSelected,
    this.enabled = true,
    this.validator,
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
        return TextFormField(
          controller: textEditingController,
          focusNode: fieldFocusNode,
          enabled: enabled,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: premiumTextColor),
          cursorColor: goldPrimaryColor,
          validator: validator,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
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
  final List<SelectedGalleryImage> images;
  final VoidCallback onTap;
  final ValueChanged<int> onClearImage;
  final VoidCallback onClearAll;

  const _ImagePickerField({
    required this.images,
    required this.onTap,
    required this.onClearImage,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty;
    final isTablet = MediaQuery.of(context).size.width > 600;
    final thumbSize = isTablet ? 110.0 : 74.0;

    return Material(
      color: transparentColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            minHeight: hasImages ? (thumbSize + 76) : 58,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: premiumSurfaceTintColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: premiumGoldBorderColor),
          ),
          child: Row(
            crossAxisAlignment: hasImages
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: premiumSurfaceColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: premiumGoldBorderColor),
                ),
                clipBehavior: Clip.antiAlias,
                child: const Icon(
                  Icons.image_outlined,
                  color: goldPrimaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasImages
                          ? '${images.length} images selected'
                          : 'Upload Images',
                      style: const TextStyle(
                        color: premiumTextColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasImages
                          ? 'Tap to add more images'
                          : 'Choose from camera or gallery',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: premiumMutedTextColor),
                    ),
                    if (hasImages) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        height: thumbSize,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final image = images[index];

                            return Stack(
                              children: [
                                Container(
                                  width: thumbSize,
                                  height: thumbSize,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: premiumGoldBorderColor,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.memory(
                                    image.bytes,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 2,
                                  child: InkWell(
                                    onTap: () => onClearImage(index),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      width: 22,
                                      height: 22,
                                      decoration: const BoxDecoration(
                                        color: luxuryBlackColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 15,
                                        color: whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasImages)
                IconButton(
                  tooltip: 'Remove all images',
                  onPressed: onClearAll,
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
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final FormFieldValidator<String>? validator;

  const _RequestTextField({
    required this.controller,
    required this.labelText,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
        ),
      ),
    );
  }
}
