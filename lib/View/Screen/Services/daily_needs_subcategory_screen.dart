import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:echosphere/View/Widgets/category_card.dart';

class DailyNeedsSubcategoryScreen extends StatefulWidget {
  const DailyNeedsSubcategoryScreen({super.key});

  @override
  State<DailyNeedsSubcategoryScreen> createState() =>
      _DailyNeedsSubcategoryScreenState();
}

class _DailyNeedsSubcategoryScreenState
    extends State<DailyNeedsSubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.bottleWater,
      'title': 'Milk & Dairy',
      'color': const Color(0xFF2196F3),
      'description': 'Fresh milk, curd, and dairy products',
    },
    {
      'icon': FontAwesomeIcons.breadSlice,
      'title': 'Bakery',
      'color': const Color(0xFF795548),
      'description': 'Bread, cakes, and cookies',
    },
    {
      'icon': FontAwesomeIcons.newspaper,
      'title': 'Newspaper Vendor',
      'color': const Color(0xFF607D8B),
      'description': 'Daily newspaper delivery',
    },
    {
      'icon': FontAwesomeIcons.droplet,
      'title': 'Water Supply',
      'color': const Color(0xFF03A9F4),
      'description': 'Drinking water jar delivery',
    },
    {
      'icon': FontAwesomeIcons.gasPump,
      'title': 'Gas Agency',
      'color': const Color(0xFFFF5722),
      'description': 'LPG cylinder booking & delivery',
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
                color: const Color(0xFF2196F3).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.basketShopping,
                color: Color(0xFF2196F3),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Daily Needs',
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
              hintText: "Search daily needs...",
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

            /// ✅ PERFECT SPACING
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
