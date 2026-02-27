import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/view/widgets/category_card.dart';
import 'package:echosphere/view/widgets/search_filter.dart';
import 'package:echosphere/models/category_model.dart';
import 'package:echosphere/view/screen/Services/healthcare_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/agricultural_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/hotels_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/home_utilities_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/garments_footwear_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/grocery_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/jewellery_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/daily_needs_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/pet_grooming_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/sports_gym_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/photography_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/personal_care_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/wedding_necessities_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/general_services_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/educational_requirements_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/masti_family_time_subcategory_screen.dart';
import 'package:echosphere/view/screen/Services/tours_travels_subcategory_screen.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {

  String _searchQuery = '';

  /// ✅ TYPE SAFE CATEGORY LIST
  final List<Category> _allCategories = const [

    Category(
      icon: FontAwesomeIcons.heartPulse,
      title: 'Healthcare',
      color: Colors.redAccent,
      screen: HealthcareSubcategoryScreen(),
    ),

    Category(
      icon: Icons.local_florist,
      title: 'Agricultural Requirements',
      color: Color(0xFF2196F3),
      screen: AgriculturalSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.hotel,
      title: 'Hotels',
      color: Color(0xFFFFC107),
      screen: HotelsSubcategoryScreen(),
    ),

    Category(
      icon: Icons.home,
      title: 'Home Utilities',
      color: Color(0xFF9C27B0),
      screen: HomeUtilitiesSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.shirt,
      title: 'Garments & Footwear',
      color: Color(0xFF00BCD4),
      screen: GarmentsFootwearSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.basketShopping,
      title: 'Grocery',
      color: Color(0xFF4CAF50),
      screen: GrocerySubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.gem,
      title: 'Jewellery',
      color: Color(0xFFFFD700),
      screen: JewellerySubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.bottleWater,
      title: 'Daily Needs',
      color: Color(0xFF03A9F4),
      screen: DailyNeedsSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.paw,
      title: 'Pet Grooming Centers',
      color: Color(0xFF795548),
      screen: PetGroomingSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.dumbbell,
      title: 'Sports & Gym',
      color: Color(0xFFD32F2F),
      screen: SportsGymSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.camera,
      title: 'Photography',
      color: Color(0xFF5C6BC0),
      screen: PhotographySubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.spa,
      title: 'Personal Care',
      color: Color(0xFFF48FB1),
      screen: PersonalCareSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.heart,
      title: 'Wedding Necessities',
      color: Color(0xFFEF5350),
      screen: WeddingNecessitiesSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.screwdriverWrench,
      title: 'Services',
      color: Color(0xFF607D8B),
      screen: GeneralServicesSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.bookOpenReader,
      title: 'Educational Requirements',
      color: Color(0xFFFF9800),
      screen: EducationalRequirementsSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.masksTheater,
      title: 'Masti & Family Time',
      color: Color(0xFFE91E63),
      screen: MastiFamilyTimeSubcategoryScreen(),
    ),

    Category(
      icon: FontAwesomeIcons.plane,
      title: 'Tours & Travels',
      color: Color(0xFF1976D2),
      screen: ToursTravelsSubcategoryScreen(),
    ),
  ];

  /// ✅ SEARCH FILTER
  List<Category> get _filteredCategories {
    if (_searchQuery.isEmpty) return _allCategories;

    return _allCategories.where((category) {
      return category.title
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        toolbarHeight: 56,
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: SearchFilterBar(
              hintText: 'Search services...',
              onSearchChanged: _onSearchChanged,
              showFilterButton: false,
            ),
          ),
        ),
      ),

      body: _filteredCategories.isEmpty
          ? const Center(child: Text('No services found'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              itemCount: _filteredCategories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 18),

              itemBuilder: (context, index) {
                final category = _filteredCategories[index];

                return CategoryCard(
                  icon: category.icon,
                  title: category.title,
                  color: category.color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => category.screen,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
