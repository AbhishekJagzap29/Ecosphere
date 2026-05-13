import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  static const List<String> _talukas = [
    'Ajra',
    'Akole',
    'Ambegaon',
    'Atpadi',
    'Baramati',
    'Bhor',
    'Bhudargad',
    'Chandgad',
    'Daund',
    'Gadhinglaj',
    'Hatkanangle',
    'Haveli',
    'Indapur',
    'Jaoli',
    'Jat',
    'Junnar',
    'Kadegaon',
    'Kagal',
    'Karad',
    'Karvir',
    'Kavathe Mahankal',
    'Khanapur',
    'Khatav',
    'Khed',
    'Kolhapur',
    'Koregaon',
    'Mahabaleshwar',
    'Man',
    'Maval',
    'Miraj',
    'Mulshi',
    'Palus',
    'Panhala',
    'Patan',
    'Phaltan',
    'Pune City',
    'Purandar',
    'Radhanagari',
    'Sangamner',
    'Satara',
    'Shahuwadi',
    'Shirala',
    'Shirol',
    'Shirur',
    'Tasgaon',
    'Velhe',
    'Wai',
    'Walwa',
    'Kopergaon',
    'Yeola',
  ];

  Future<void> _submitRegistration() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
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
                          _TalukaAutocomplete(
                            controller: _talukaController,
                            talukas: _talukas,
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitRegistration,
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
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

class _TalukaAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final List<String> talukas;

  const _TalukaAutocomplete({
    required this.controller,
    required this.talukas,
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
    return RawAutocomplete<String>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) {
          return widget.talukas;
        }

        return widget.talukas.where(
          (taluka) => taluka.toLowerCase().contains(query),
        );
      },
      displayStringForOption: (option) => option,
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
          validator: (value) {
            final taluka = value?.trim() ?? '';
            if (taluka.isEmpty) {
              return 'Taluka is required';
            }

            final isKnownTaluka = widget.talukas.any(
              (option) => option.toLowerCase() == taluka.toLowerCase(),
            );
            if (!isKnownTaluka) {
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
                      option,
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
