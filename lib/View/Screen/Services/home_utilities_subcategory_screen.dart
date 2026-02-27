import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:echosphere/View/Widgets/category_card.dart';

class HomeUtilitiesSubcategoryScreen extends StatefulWidget {
  const HomeUtilitiesSubcategoryScreen({super.key});

  @override
  State<HomeUtilitiesSubcategoryScreen> createState() =>
      _HomeUtilitiesSubcategoryScreenState();
}

class _HomeUtilitiesSubcategoryScreenState
    extends State<HomeUtilitiesSubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.boltLightning,
      'title': 'Electrical Shop',
      'color': const Color(0xFF9C27B0),
      'description': 'Wiring, switches, and electrical supplies',
    },
    {
      'icon': FontAwesomeIcons.tv,
      'title': 'Electronics',
      'color': const Color(0xFFAB47BC),
      'description': 'TVs, appliances, and gadgets',
    },
    {
      'icon': FontAwesomeIcons.couch,
      'title': 'Furnishes',
      'color': const Color(0xFFBA68C8),
      'description': 'Furniture and home decor',
    },
    {
      'icon': FontAwesomeIcons.gift,
      'title': 'Gifts & Antiques',
      'color': const Color(0xFFCE93D8),
      'description': 'Unique gifts and collectibles',
    },
    {
      'icon': FontAwesomeIcons.kitchenSet,
      'title': 'Kitchen Utilities',
      'color': const Color(0xFF8E24AA),
      'description': 'Cookware, utensils, and appliances',
    },
    {
      'icon': FontAwesomeIcons.mobileScreen,
      'title': 'Mobile Accessories',
      'color': const Color(0xFF7B1FA2),
      'description': 'Cases, chargers, and phone accessories',
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
                color: const Color(0xFF9C27B0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.home,
                color: Color(0xFF9C27B0),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Home Utilities',
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
              hintText: "Search home utilities...",
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 10),

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

            /// ✅ LIST WITH PROPER GAP
            Expanded(
              child: filteredSubcategories.isEmpty
                  ? const Center(
                      child: Text(
                        "No results found",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.only(bottom: 30),
                      itemCount: filteredSubcategories.length,

                      /// ⭐ THIS CREATES GAP
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
