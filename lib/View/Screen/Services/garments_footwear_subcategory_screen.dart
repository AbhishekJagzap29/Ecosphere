import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:echosphere/View/Widgets/category_card.dart';

class GarmentsFootwearSubcategoryScreen extends StatefulWidget {
  const GarmentsFootwearSubcategoryScreen({super.key});

  @override
  State<GarmentsFootwearSubcategoryScreen> createState() =>
      _GarmentsFootwearSubcategoryScreenState();
}

class _GarmentsFootwearSubcategoryScreenState
    extends State<GarmentsFootwearSubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.shirt,
      'title': 'Men\'s Clothing',
      'color': const Color(0xFF00BCD4),
      'description': 'Shirts, pants, and formal wear',
    },
    {
      'icon': Icons.checkroom,
      'title': 'Women\'s Clothing',
      'color': const Color(0xFF26C6DA),
      'description': 'Dresses, sarees, and ethnic wear',
    },
    {
      'icon': FontAwesomeIcons.child,
      'title': 'Kids Clothing',
      'color': const Color(0xFF4DD0E1),
      'description': 'Children\'s apparel and accessories',
    },
    {
      'icon': FontAwesomeIcons.shoePrints,
      'title': 'Footwear',
      'color': const Color(0xFF80DEEA),
      'description': 'Shoes, sandals, and slippers',
    },
    {
      'icon': FontAwesomeIcons.bagShopping,
      'title': 'Bags & Accessories',
      'color': const Color(0xFF0097A7),
      'description': 'Handbags, wallets, and belts',
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
                color: const Color(0xFF00BCD4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.shopping_cart_rounded,
                color: Color(0xFF00BCD4),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Garments & Footwear',
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
              hintText: "Search garments, footwear...",
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
