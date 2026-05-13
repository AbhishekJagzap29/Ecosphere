import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Screen/About/Events.dart';
import 'package:echosphere/View/Screen/About/Executive.dart';
import 'package:echosphere/View/Screen/About/Updates.dart';
import 'package:echosphere/View/Screen/About/about_company.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 110),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AboutHeader(),
            const SizedBox(height: 24),
            _buildTile(
              icon: Icons.people,
              title: 'About Company',
              subtitle: 'Know who we are and what Echosphere stands for',
              onTap: () => _openScreen(
                context,
                const AboutCompanyScreen(),
              ),
            ),
            _buildTile(
              icon: Icons.calendar_month_outlined,
              title: 'Events',
              subtitle: 'Explore upcoming company events and activities',
              onTap: () => _openScreen(
                context,
                const EventsScreen(),
              ),
            ),
            _buildTile(
              icon: Icons.newspaper_outlined,
              title: 'Updates',
              subtitle: 'Read the latest news, launches, and announcements',
              onTap: () => _openScreen(
                context,
                const UpdatesScreen(),
              ),
            ),
            _buildTile(
              icon: Icons.person_add_alt_1,
              title: 'Executive',
              subtitle: 'Access the executive login and internal tools',
              onTap: () => _openScreen(
                context,
                const ExcecutiveScreen(),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Product by Echosphere',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: grey500Color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _AboutTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: onTap,
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }
}

class _AboutHeader extends StatelessWidget {
  const _AboutHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            luxuryBlackColor,
            luxuryBlackAltColor,
            goldPrimaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: premiumGoldBorderColor),
        boxShadow: const [
          BoxShadow(
            color: premiumShadowColor,
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
          BoxShadow(
            color: premiumGoldShadowColor,
            blurRadius: 34,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -28,
            child: Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: whiteOverlay10Color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -34,
            bottom: -42,
            child: Container(
              width: 130,
              height: 130,
              decoration: const BoxDecoration(
                color: whiteOverlay10Color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.eco_rounded,
                color: goldHighlightColor,
                size: 34,
              ),
              SizedBox(height: 18),
              Text(
                'Echosphere',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Premium local services, updates, events, and member access in one refined experience.',
                style: TextStyle(
                  color: whiteOverlay80Color,
                  fontSize: 13.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AboutTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(16),
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
            BoxShadow(
              color: premiumGoldShadowColor,
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: greenTintColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: premiumGoldBorderColor),
              ),
              child: Icon(
                icon,
                size: 27,
                color: goldPrimaryColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: premiumTextColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12.8,
                      height: 1.35,
                      color: premiumMutedTextColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: premiumSurfaceTintColor,
                shape: BoxShape.circle,
                border: Border.all(color: premiumGoldBorderColor),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: goldPrimaryColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}