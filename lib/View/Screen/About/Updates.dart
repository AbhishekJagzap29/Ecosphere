import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AboutDetailScreen(
      title: 'Updates',
      icon: Icons.newspaper_rounded,
      heading: 'News and Updates',
      description:
          'Find the latest announcements, service updates, launches, and important notices from Echosphere.',
    );
  }
}

class _AboutDetailScreen extends StatelessWidget {
  final String title;
  final IconData icon;
  final String heading;
  final String description;

  const _AboutDetailScreen({
    required this.title,
    required this.icon,
    required this.heading,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: premiumSurfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: premiumGoldBorderColor),
            boxShadow: const [
              BoxShadow(
                color: premiumShadowColor,
                blurRadius: 22,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: goldPrimaryColor, size: 42),
              const SizedBox(height: 18),
              Text(
                heading,
                style: const TextStyle(
                  color: premiumTextColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(
                  color: premiumMutedTextColor,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
