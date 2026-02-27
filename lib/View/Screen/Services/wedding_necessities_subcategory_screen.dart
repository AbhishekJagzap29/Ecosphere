import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WeddingNecessitiesSubcategoryScreen extends StatelessWidget {
  const WeddingNecessitiesSubcategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subcategories = [
      {
        'icon': FontAwesomeIcons.church, // Changed from mosque to church for general venue representation or use another suitable icon
        'title': 'Function Halls / Venues',
        'color': const Color(0xFFEF5350),
        'description': 'Banquet halls and lawns',
      },
      {
        'icon': FontAwesomeIcons.cameraRetro,
        'title': 'Wedding Photography',
        'color': const Color(0xFFAB47BC),
        'description': 'Capture your special moments',
      },
      {
        'icon': FontAwesomeIcons.plateWheat,
        'title': 'Catering Services',
        'color': const Color(0xFFFFA726),
        'description': 'Delicious food for guests',
      },
      {
        'icon': FontAwesomeIcons.fan, // Used for decoration
        'title': 'Decorators',
        'color': const Color(0xFF26A69A),
        'description': 'Flower and stage decoration',
      },
      {
        'icon': FontAwesomeIcons.music,
        'title': 'DJ & Band',
        'color': const Color(0xFF5C6BC0),
        'description': 'Music and entertainment',
      },
      {
        'icon': FontAwesomeIcons.clipboardList,
        'title': 'Wedding Planners',
        'color': const Color(0xFF8D6E63),
        'description': 'End-to-end event management',
      },
    ];

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
                color: const Color(0xFFEF5350).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.heart,
                color: Color(0xFFEF5350),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Wedding Necessities',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          return _SubcategoryCard(
            icon: subcategory['icon'] as IconData,
            title: subcategory['title'] as String,
            description: subcategory['description'] as String,
            color: subcategory['color'] as Color,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${subcategory['title']} selected'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _SubcategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _SubcategoryCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
