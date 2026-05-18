import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static const String _email = 'Echospherensk2024@gmail.com';
  static const String _officePhone = '8308251866';
  static const String _whatsapp = '9272031602';
  static const String _website = '';

  static const List<String> _addresses = [
    'Shop No.26, Sai Kuber Complex, Sai Kuber City, Yeola Road, Kopargaon (Ahilyanagar)',
    'Flat No.09, Narayan Deep, Housing Society Ltd., Anand Nagar, Devlali, Nashik-422401',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      appBar: AppBar(
        toolbarHeight: 72,
        title: const Column(
          children: [
            Text('Contact Us'),
            SizedBox(height: 3),
            Text(
              'ECHOSPHERE MULTI SERVICES PVT. LTD.',
              style: TextStyle(
                color: premiumMutedTextColor,
                fontSize: 10.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          const _BackgroundGlow(),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _CompanyCard(),
                const SizedBox(height: 18),
                _ContactActionTile(
                  icon: Icons.email_outlined,
                  title: 'Email',
                  value: _email,
                  onTap: () => _launchEmail(_email),
                ),
                _ContactActionTile(
                  icon: Icons.call_outlined,
                  title: 'Telephone No.',
                  value: _officePhone,
                  onTap: () => _launchPhone(_officePhone),
                ),
                _ContactActionTile(
                  icon: Icons.phone_android_rounded,
                  title: 'Phone No.',
                  value: _officePhone,
                  onTap: () => _launchPhone(_officePhone),
                ),
                _ContactActionTile(
                  icon: Icons.chat_outlined,
                  title: 'WhatsApp No.',
                  value: _whatsapp,
                  onTap: () => _launchWhatsApp(_whatsapp),
                ),
                _ContactActionTile(
                  icon: Icons.language_rounded,
                  title: 'Website',
                  value: _website.isEmpty ? 'Not available' : _website,
                  isEnabled: _website.isNotEmpty,
                  onTap: _website.isEmpty
                      ? null
                      : () => _launchWebsite(_website),
                ),
                const SizedBox(height: 8),
                const _SectionTitle(title: 'Office Address'),
                const SizedBox(height: 12),
                ..._addresses.map(
                  (address) => _ContactActionTile(
                    icon: Icons.location_on_outlined,
                    title: 'Office',
                    value: address,
                    onTap: () => _launchMap(address),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _launchPhone(String number) async {
    await _openUri(Uri(scheme: 'tel', path: number));
  }

  static Future<void> _launchEmail(String email) async {
    await _openUri(
      Uri(
        scheme: 'mailto',
        path: email,
      ),
    );
  }

  static Future<void> _launchWhatsApp(String number) async {
    final digits = number.replaceAll(RegExp(r'[^0-9]'), '');
    await _openUri(
      Uri.parse('https://wa.me/91$digits'),
    );
  }

  static Future<void> _launchWebsite(String website) async {
    final normalized = website.startsWith(RegExp(r'https?://'))
        ? website
        : 'https://$website';
    await _openUri(Uri.parse(normalized));
  }

  static Future<void> _launchMap(String address) async {
    final query = Uri.encodeComponent(address);
    final appUri = Uri.parse('geo:0,0?q=$query');
    final webUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$query',
    );

    try {
      final opened = await launchUrl(
        appUri,
        mode: LaunchMode.externalApplication,
      );
      if (opened) return;
    } catch (_) {
      // Fall back to Google Maps in browser if a maps app is unavailable.
    }

    await _openUri(webUri);
  }

  static Future<void> _openUri(Uri uri) async {
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (error) {
      debugPrint('Could not launch $uri: $error');
    }
  }
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: premiumGoldBorderColor),
        gradient: const LinearGradient(
          colors: [
            luxuryBlackColor,
            premiumSurfaceTintColor,
            premiumSurfaceColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: premiumShadowColor,
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
          BoxShadow(
            color: premiumGoldShadowColor,
            blurRadius: 28,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 72,
            width: 72,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: luxuryBlackColor,
              border: Border.all(color: premiumGoldBorderColor),
            ),
            child: Image.asset(
              'assets/images/logo.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.eco_rounded,
                  color: goldPrimaryColor,
                  size: 36,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ECHOSPHERE',
                  style: TextStyle(
                    color: goldPrimaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'MULTI SERVICES PVT. LTD.',
                  style: TextStyle(
                    color: premiumTextColor,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'CIN-U73200MH2024PTC435914',
                  style: TextStyle(
                    color: premiumMutedTextColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: goldPrimaryColor,
        fontSize: 17,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

class _ContactActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;
  final bool isEnabled;

  const _ContactActionTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        isEnabled ? premiumTextColor : premiumMutedTextColor;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: premiumSurfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: premiumGoldBorderColor),
          boxShadow: const [
            BoxShadow(
              color: premiumShadowColor,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: greenTintColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: premiumGoldBorderColor),
              ),
              child: Icon(
                icon,
                color: isEnabled ? goldPrimaryColor : premiumMutedTextColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: premiumMutedTextColor,
                      fontSize: 12.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      color: effectiveTextColor,
                      fontSize: 14.6,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (isEnabled) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.open_in_new_rounded,
                color: goldPrimaryColor,
                size: 19,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 36,
          right: -70,
          child: _GlowSpot(size: 190, opacity: 0.08),
        ),
        Positioned(
          bottom: 64,
          left: -88,
          child: _GlowSpot(size: 220, opacity: 0.055),
        ),
      ],
    );
  }
}

class _GlowSpot extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowSpot({
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: goldPrimaryColor.withOpacity(opacity),
      ),
    );
  }
}
