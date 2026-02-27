import 'package:echosphere/View/Screen/Services/category_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';

class AgriculturalSubcategoryScreen extends StatefulWidget {
  const AgriculturalSubcategoryScreen({super.key});

  @override
  State<AgriculturalSubcategoryScreen> createState() =>
      _AgriculturalSubcategoryScreenState();
}

class _AgriculturalSubcategoryScreenState
    extends State<AgriculturalSubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.seedling,
      'title': 'Kheti',
      'color': const Color(0xFF2E7D32),
      'description': 'Farming and crop cultivation',
    },
    {
      'icon': FontAwesomeIcons.tractor,
      'title': 'Machines',
      'color': const Color(0xFF388E3C),
      'description': 'Agricultural machinery and equipment',
    },
    {
      'icon': FontAwesomeIcons.sprayCan,
      'title': 'Fertilizers & Pesticides',
      'color': const Color(0xFF43A047),
      'description': 'Crop protection and nutrients',
    },
    {
      'icon': FontAwesomeIcons.droplet,
      'title': 'Irrigation',
      'color': const Color(0xFF4CAF50),
      'description': 'Water management systems',
    },
    {
      'icon': FontAwesomeIcons.leaf,
      'title': 'Seeds & Plants',
      'color': const Color(0xFF66BB6A),
      'description': 'Quality seeds and saplings',
    },
  ];

  @override
  Widget build(BuildContext context) {

    /// 🔥 FILTER LOGIC
    final filteredSubcategories = _allSubcategories.where((subcategory) {
      final title = subcategory['title'].toString().toLowerCase();
      final description =
          subcategory['description'].toString().toLowerCase();

      return title.contains(_searchQuery.toLowerCase()) ||
          description.contains(_searchQuery.toLowerCase());
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
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.tractor,
                color: Color(0xFF2E7D32),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Agricultural Requirements',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// ✅ SEARCH BAR
            SearchFilterBar(
              hintText: "Search agricultural services...",
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 10),

            /// ✅ LIST
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
                  : ListView.builder(
                      itemCount: filteredSubcategories.length,
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
