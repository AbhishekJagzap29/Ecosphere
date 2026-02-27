import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:echosphere/View/Widgets/category_card.dart';

class HotelsSubcategoryScreen extends StatefulWidget {
  const HotelsSubcategoryScreen({super.key});

  @override
  State<HotelsSubcategoryScreen> createState() =>
      _HotelsSubcategoryScreenState();
}

class _HotelsSubcategoryScreenState extends State<HotelsSubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.hotel,
      'title': 'Hotels',
      'color': const Color(0xFFE91E63),
      'description': 'Comfortable stays and accommodations',
    },
    {
      'icon': FontAwesomeIcons.utensils,
      'title': 'Restaurants',
      'color': const Color(0xFFF06292),
      'description': 'Fine dining and food services',
    },
    {
      'icon': FontAwesomeIcons.wineGlass,
      'title': 'Bars',
      'color': const Color(0xFFEC407A),
      'description': 'Drinks and nightlife venues',
    },
    {
      'icon': FontAwesomeIcons.mugHot,
      'title': 'Cafes',
      'color': const Color(0xFFF48FB1),
      'description': 'Coffee shops and casual dining',
    },
    {
      'icon': FontAwesomeIcons.plateWheat,
      'title': 'Catering Services',
      'color': const Color(0xFFAD1457),
      'description': 'Event catering and food delivery',
    },
  ];

  @override
  Widget build(BuildContext context) {

    /// ✅ Optimized search
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
                color: const Color(0xFFE91E63).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.hotel,
                color: Color(0xFFE91E63),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Hotels & Dining',
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

            /// 🔥 SEARCH
            SearchFilterBar(
              hintText: "Search hotels, cafes, restaurants...",
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 10),

            /// ⭐ Result count
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

            /// ✅ LIST WITH PERFECT SPACING
            Expanded(
              child: filteredSubcategories.isEmpty
                  ? const Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 30), // ⭐ important
                      itemCount: filteredSubcategories.length,

                      /// ⭐ THIS CREATES THE GAP
                      separatorBuilder: (context, index) =>
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
                                content: Text(
                                    '${subcategory['title']} selected'),
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
