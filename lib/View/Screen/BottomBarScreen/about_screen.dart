import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  /// 📞 Call Function
  Future<void> _makePhoneCall() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '+919876543210');

    if (!await launchUrl(phoneUri)) {
      throw Exception('Could not launch $phoneUri');
    }
  }

  /// 📧 Email Function
  Future<void> _sendEmail() async {
    final Uri emailUri =
        Uri(scheme: 'mailto', path: 'support@echosphere.com');

    if (!await launchUrl(emailUri)) {
      throw Exception('Could not launch $emailUri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// LOGO
          Image.asset(
            'assets/images/logo.png',
            height: 100,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.eco,
                color: Color(0xFF2E7D32),
                size: 100,
              );
            },
          ),

          const SizedBox(height: 20),

          const Text(
            "ECHOSPHERE",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
              letterSpacing: 2,
            ),
          ),

          const SizedBox(height: 40),

          /// TITLE LEFT ALIGNED (more professional)
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Our Mission",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// ✅ JUSTIFIED TEXT (IMPORTANT FIX)
          const Text(
            "Echosphere is dedicated to connecting you with the best local services in your area. From healthcare to daily needs, we bridge the gap between customers and quality service providers.",
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              height: 1.7,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 40),

          /// CONTACT CARD
          Card(
            elevation: 4,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              child: Column(
                children: [

                  const Text(
                    "Contact Support",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// EMAIL TILE
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _sendEmail,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFE8F5E9),
                            child: Icon(
                              Icons.email_outlined,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "support@echosphere.com",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16)
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// PHONE TILE
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _makePhoneCall,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFE8F5E9),
                            child: Icon(
                              Icons.phone_outlined,
                              color: Color(0xFF2E7D32),
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              "+91 98765 43210",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 16)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
