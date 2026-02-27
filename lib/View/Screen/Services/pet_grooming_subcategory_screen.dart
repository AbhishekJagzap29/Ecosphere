import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:echosphere/View/Widgets/category_card.dart';

class PetGroomingSubcategoryScreen extends StatefulWidget {
  const PetGroomingSubcategoryScreen({super.key});

  @override
  State<PetGroomingSubcategoryScreen> createState() =>
      _PetGroomingSubcategoryScreenState();
}

class _PetGroomingSubcategoryScreenState
    extends State<PetGroomingSubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.paw,
      'title': 'Pet Shops',
      'color': const Color(0xFF795548),
      'description': 'Pet supplies, food, and accessories',
    },
    {
      'icon': FontAwesomeIcons.userDoctor,
      'title': 'Vet Clinics',
      'color': const Color(0xFFEF5350),
      'description': 'Veterinary doctors and hospitals',
    },
    {
      'icon': FontAwesomeIcons.scissors,
      'title': 'Pet Grooming',
      'color': const Color(0xFFAB47BC),
      'description': 'Bathing, haircut, and spa for pets',
    },
    {
      'icon': FontAwesomeIcons.dog,
      'title': 'Dog Training',
      'color': const Color(0xFFFFA726),
      'description': 'Professional dog trainers',
    },
    {
      'icon': FontAwesomeIcons.houseUser,
      'title': 'Pet Boarding',
      'color': const Color(0xFF26A69A),
      'description': 'Pet hostels and day care',
    },
  ];

  @override
  Widget build(BuildContext context) {

    final query = _searchQuery.trim().toLowerCase();

    final filteredSubcategories = _allSubcategories.where((subcategory) {
      final title = (subcategory['title'] as String).toLowerCase();
      final description =
          (subcategory['description'] as String).toLowerCase();

      return title.contains(query) || description.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF333333)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF795548).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.paw,
                color: Color(0xFF795548),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Pet Care Center',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [

            /// 🔥 SEARCH BAR
            SearchFilterBar(
              hintText: "Search pet services...",
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 10),

            /// ⭐ RESULT COUNT
            if (_searchQuery.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${filteredSubcategories.length} results found",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),

            const SizedBox(height: 8),

            /// ✅ PERFECTLY SPACED LIST
            Expanded(
              child: filteredSubcategories.isEmpty
                  ? const Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 30),
                      itemCount: filteredSubcategories.length,

                      /// ⭐ GAP BETWEEN CARDS
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 18),

                      itemBuilder: (context, index) {
                        final subcategory = filteredSubcategories[index];

                        return CategoryCard(
                          icon: subcategory['icon'],
                          title: subcategory['title'],
                          description: subcategory['description'],
                          color: subcategory['color'],
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${subcategory['title']} selected'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
