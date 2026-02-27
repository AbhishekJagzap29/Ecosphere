import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:echosphere/View/Screen/Subcategories/Healthcare/hospitals_screen.dart';

class HealthcareSubcategoryScreen extends StatefulWidget {
  const HealthcareSubcategoryScreen({super.key});

  @override
  State<HealthcareSubcategoryScreen> createState() =>
      _HealthcareSubcategoryScreenState();
}

class _HealthcareSubcategoryScreenState
    extends State<HealthcareSubcategoryScreen> {

  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSubcategories = [
    {
      'icon': FontAwesomeIcons.hospital,
      'title': 'Hospitals',
      'color': const Color(0xFFE53935),
      'description': 'Find nearby hospitals',
    },
    {
      'icon': FontAwesomeIcons.clinicMedical,
      'title': 'Clinics',
      'color': const Color(0xFFD32F2F),
      'description': 'Medical clinics near you',
    },
    {
      'icon': FontAwesomeIcons.userDoctor,
      'title': 'General Physicians',
      'color': const Color(0xFFC62828),
      'description': 'Consult general doctors',
    },
    {
      'icon': FontAwesomeIcons.stethoscope,
      'title': 'Specialists',
      'color': const Color(0xFFB71C1C),
      'description': 'Cardiologis t, Dermatologist, Orthopedic, etc.',
    },
    {
      'icon': FontAwesomeIcons.tooth,
      'title': 'Dentists',
      'color': const Color(0xFFEF5350),
      'description': 'Dental care services',
    },
  ];

  @override
  Widget build(BuildContext context) {

    /// 🔥 FILTER LOGIC
    final filteredSubcategories = _allSubcategories.where((subcategory) {
      final title = subcategory['title'].toString().toLowerCase();
      return title.contains(_searchQuery.toLowerCase());
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
                color: const Color(0xFFE53935).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FaIcon(
                FontAwesomeIcons.heartPulse,
                color: Color(0xFFE53935),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Healthcare Services',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// ✅ SEARCH BAR (Reusable)
            SearchFilterBar(
              hintText: "Search healthcare services...",
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),

            const SizedBox(height: 10),

            /// LIST
            Expanded(
              child: filteredSubcategories.isEmpty
                  ? const Center(
                      child: Text(
                        "No services found",
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

                        return _SubcategoryCard(
                          icon: subcategory['icon'],
                          title: subcategory['title'],
                          description: subcategory['description'],
                          color: subcategory['color'],
                          onTap: () {
                            if (subcategory['title'] == 'Hospitals') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HospitalsScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('${subcategory['title']} selected'),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
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
                  child: FaIcon(icon, color: color, size: 28),
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
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(Icons.arrow_forward_ios, size: 16, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
