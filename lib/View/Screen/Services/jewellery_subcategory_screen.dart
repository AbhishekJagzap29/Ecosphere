import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:echosphere/View/Widgets/category_card.dart';

class JewellerySubcategoryScreen extends StatefulWidget {
  const JewellerySubcategoryScreen({super.key});

  @override
  State<JewellerySubcategoryScreen> createState() =>
      _JewellerySubcategoryScreenState();
}

class _JewellerySubcategoryScreenState
    extends State<JewellerySubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.gem,
      'title': 'Gold Jewellery',
      'color': const Color(0xFFFFD700),
      'description': 'Traditional and modern gold ornaments',
    },
    {
      'icon': FontAwesomeIcons.ring,
      'title': 'Diamond Jewellery',
      'color': const Color(0xFFB9F2FF),
      'description': 'Exquisite diamond collections',
    },
    {
      'icon': FontAwesomeIcons.coins,
      'title': 'Silver Articles',
      'color': const Color(0xFFC0C0C0),
      'description': 'Silver utensils and jewelry',
    },
    {
      'icon': FontAwesomeIcons.gem,
      'title': 'Imitation Jewellery',
      'color': const Color(0xFFE91E63),
      'description': 'Trendy artificial jewelry',
    },
    {
      'icon': FontAwesomeIcons.crown,
      'title': 'Platinum Collections',
      'color': const Color(0xFFE5E4E2),
      'description': 'Premium platinum bands and sets',
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
                color: const Color(0xFFFFD700).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.gem,
                color: Color(0xFFFFD700),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Jewellery',
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
              hintText: "Search jewellery...",
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

                      /// ⭐ CREATES PERFECT GAP
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
