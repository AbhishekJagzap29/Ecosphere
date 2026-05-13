import 'package:echosphere/Api/ResponseModel/taluka_response_model.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';
import 'package:echosphere/View/Controller/customer_registration_controller.dart';
import 'package:echosphere/View/Controller/taluka_controller.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/home_screen.dart';
import 'package:echosphere/View/Utils/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _talukaController = TextEditingController();
  late final CustomerRegistrationController _registrationController;
  TalukaData? _selectedTaluka;
  bool _isCardHolder = false;

  @override
  void initState() {
    super.initState();
    _registrationController = Get.isRegistered<CustomerRegistrationController>()
        ? Get.find<CustomerRegistrationController>()
        : Get.put(CustomerRegistrationController());
    final talukaController = Get.isRegistered<TalukaController>()
        ? Get.find<TalukaController>()
        : Get.put(TalukaController());
    talukaController.getTalukas();
  }

  Future<void> _submitRegistration() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final selectedTalukaId = _selectedTaluka?.id;
    if (selectedTalukaId == null) {
      errorSnackBar(
        'Taluka Required',
        'Please select a valid taluka from the dropdown',
      );
      return;
    }

    final response = await _registrationController.registerCustomer(
      name: _nameController.text.trim(),
      phone: _mobileController.text.trim(),
      talukaId: selectedTalukaId,
      isCardHolder: _isCardHolder,
    );

    if (response?.status?.toLowerCase() != 'success') {
      return;
    }

    await preferences.putString(
      SharedPreference.registeredFullName,
      _nameController.text.trim(),
    );
    await preferences.putString(
      SharedPreference.registeredMobileNo,
      _mobileController.text.trim(),
    );
    await preferences.putString(
      SharedPreference.registeredTaluka,
      _talukaController.text.trim(),
    );
    await preferences.putInt(
      SharedPreference.registeredTalukaId,
      selectedTalukaId,
    );
    await preferences.putBool(
      SharedPreference.registeredIsCardHolder,
      _isCardHolder,
    );
    if (response?.customerId != null) {
      await preferences.putInt(
        SharedPreference.registeredCustomerId,
        response!.customerId!,
      );
    }
    await preferences.putBool(SharedPreference.isUserRegistered, true);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _talukaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              luxuryBlackColor,
              luxuryBlackAltColor,
              luxuryBlackColor,
            ],
            stops: [0, 0.52, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  decoration: BoxDecoration(
                    color: premiumSurfaceColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: premiumGoldBorderColor),
                    boxShadow: const [
                      BoxShadow(
                        color: premiumShadowColor,
                        blurRadius: 30,
                        offset: Offset(0, 18),
                      ),
                      BoxShadow(
                        color: premiumGoldShadowColor,
                        blurRadius: 34,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 82,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.eco,
                                size: 80,
                                color: goldPrimaryColor,
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'User Registration',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                              color: premiumTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Complete this once to continue',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: premiumMutedTextColor,
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: _nameController,
                            textInputAction: TextInputAction.next,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter full name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Full name is required';
                              }

                              if (value.trim().length < 3) {
                                return 'Enter a valid full name';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: _mobileController,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            decoration: const InputDecoration(
                              labelText: 'Mobile No',
                              hintText: 'Enter 10 digit mobile number',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                            validator: (value) {
                              final mobile = value?.trim() ?? '';
                              if (mobile.isEmpty) {
                                return 'Mobile number is required';
                              }

                              if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
                                return 'Mobile number must be 10 digits';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          GetBuilder<TalukaController>(
                            builder: (controller) {
                              if (controller.isLoading &&
                                  controller.talukas.isEmpty) {
                                return const _TalukaLoadingField();
                              }

                              if (controller.talukas.isEmpty) {
                                return _TalukaErrorField(
                                  onRetry: controller.getTalukas,
                                );
                              }

                              return _TalukaAutocomplete(
                                controller: _talukaController,
                                talukas: controller.talukas,
                                selectedTaluka: _selectedTaluka,
                                onSelected: (taluka) {
                                  setState(() {
                                    _selectedTaluka = taluka;
                                  });
                                },
                                onChanged: (value) {
                                  if (_selectedTaluka?.name != value) {
                                    setState(() {
                                      _selectedTaluka = null;
                                    });
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          _DiscountCardHolderField(
                            value: _isCardHolder,
                            onChanged: (value) {
                              setState(() {
                                _isCardHolder = value;
                              });
                            },
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: GetBuilder<CustomerRegistrationController>(
                              builder: (controller) {
                                return ElevatedButton(
                                  onPressed: controller.isLoading
                                      ? null
                                      : _submitRegistration,
                                  child: controller.isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: blackColor,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'Submit',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscountCardHolderField extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _DiscountCardHolderField({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      activeColor: goldPrimaryColor,
      tileColor: premiumSurfaceTintColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: premiumBorderColor),
      ),
      title: const Text(
        'Are you discount card holder?',
        style: TextStyle(
          color: premiumTextColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        value ? 'Yes' : 'No',
        style: const TextStyle(
          color: premiumMutedTextColor,
          fontSize: 13,
        ),
      ),
      secondary: const Icon(
        Icons.card_membership_outlined,
        color: goldPrimaryColor,
      ),
    );
  }
}

class _TalukaLoadingField extends StatelessWidget {
  const _TalukaLoadingField();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Taluka',
        hintText: 'Loading talukas...',
        prefixIcon: Icon(Icons.location_on_outlined),
        suffixIcon: Padding(
          padding: EdgeInsets.all(14),
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              color: goldPrimaryColor,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
      validator: (_) => 'Please wait until talukas are loaded',
    );
  }
}

class _TalukaErrorField extends StatelessWidget {
  final Future<void> Function() onRetry;

  const _TalukaErrorField({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          readOnly: true,
          decoration: const InputDecoration(
            labelText: 'Taluka',
            hintText: 'Unable to load talukas',
            prefixIcon: Icon(Icons.location_off_outlined),
          ),
          validator: (_) => 'Please load and select taluka',
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ),
      ],
    );
  }
}

class _TalukaAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final List<TalukaData> talukas;
  final TalukaData? selectedTaluka;
  final ValueChanged<TalukaData> onSelected;
  final ValueChanged<String> onChanged;

  const _TalukaAutocomplete({
    required this.controller,
    required this.talukas,
    required this.selectedTaluka,
    required this.onSelected,
    required this.onChanged,
  });

  @override
  State<_TalukaAutocomplete> createState() => _TalukaAutocompleteState();
}

class _TalukaAutocompleteState extends State<_TalukaAutocomplete> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<TalukaData>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return widget.talukas;
        }

        return widget.talukas.where(
          (taluka) => (taluka.name ?? '').toLowerCase().contains(query),
        );
      },
      displayStringForOption: (option) => option.name ?? '',
      onSelected: widget.onSelected,
      fieldViewBuilder: (
        context,
        textEditingController,
        focusNode,
        onFieldSubmitted,
      ) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            labelText: 'Taluka',
            hintText: 'Search and select taluka',
            prefixIcon: Icon(Icons.location_on_outlined),
            suffixIcon: Icon(Icons.keyboard_arrow_down),
          ),
          onChanged: widget.onChanged,
          validator: (value) {
            final taluka = value?.trim() ?? '';
            if (taluka.isEmpty) {
              return 'Taluka is required';
            }

            final selectedMatchesText =
                widget.selectedTaluka?.name?.toLowerCase() ==
                    taluka.toLowerCase();
            final isKnownTaluka = widget.talukas.any(
              (option) => option.name?.toLowerCase() == taluka.toLowerCase(),
            );
            if (!selectedMatchesText || !isKnownTaluka) {
              return 'Please select a taluka from the dropdown';
            }

            return null;
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: premiumSurfaceTintColor,
            elevation: 8,
            borderRadius: BorderRadius.circular(14),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 220,
                maxWidth: 440,
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  color: premiumBorderColor,
                ),
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);

                  return ListTile(
                    dense: true,
                    title: Text(
                      option.name ?? '',
                      style: const TextStyle(color: premiumTextColor),
                    ),
                    onTap: () => onSelected(option),
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