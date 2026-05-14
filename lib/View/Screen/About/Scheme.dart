import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';

class SchemeScreen extends StatelessWidget {
  const SchemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SchemeDetailScreen(
      title: 'Schemes',
      icon: Icons.workspace_premium_rounded,
    );
  }
}

class _SchemeDetailScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SchemeDetailScreen({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: premiumSurfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: premiumGoldBorderColor),
            boxShadow: const [
              BoxShadow(
                color: premiumShadowColor,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  icon,
                  color: goldPrimaryColor,
                  size: 52,
                ),
              ),

              const SizedBox(height: 18),

              const Center(
                child: Text(
                  'ADVENTURE PASS',
                  style: TextStyle(
                    color: premiumTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: goldPrimaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: premiumGoldBorderColor,
                    ),
                  ),
                  child: const Text(
                    'One Card • Many Benefits',
                    style: TextStyle(
                      color: goldPrimaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 26),

              const Text(
                'We are bringing trends for you!',
                style: TextStyle(
                  color: premiumTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Only ₹2500/- for 5 years, for the whole family..!',
                style: TextStyle(
                  color: goldPrimaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 24),

              _buildSectionTitle('About The Scheme'),

              const SizedBox(height: 12),

              const Text(
                'Now get discounts on your daily shopping and service expenses!',
                style: TextStyle(
                  color: premiumTextColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'For the first time, the company has launched a unique scheme. In today’s inflation era, every middle-class family can improve their lifestyle through this scheme. This company has introduced a beneficial plan for all.',
                style: TextStyle(
                  color: premiumMutedTextColor,
                  fontSize: 14,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'The company is trying to provide all facilities around you at affordable rates.',
                style: TextStyle(
                  color: premiumMutedTextColor,
                  fontSize: 14,
                  height: 1.8,
                ),
              ),

              const SizedBox(height: 28),

              _buildSectionTitle('Available Services & Benefits'),

              const SizedBox(height: 18),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: const [
                  _BenefitChip('Hospitals'),
                  _BenefitChip('Pathological Labs'),
                  _BenefitChip('Diagnostic Centers'),
                  _BenefitChip('Family Restaurants'),
                  _BenefitChip('Eye Clinics'),
                  _BenefitChip('Medical Services'),
                  _BenefitChip('Hotels'),
                  _BenefitChip('Resorts'),
                  _BenefitChip('Super Markets'),
                  _BenefitChip('Fitness Shops'),
                  _BenefitChip('Branded Clothing'),
                  _BenefitChip('Jewellery'),
                  _BenefitChip('Personal Care'),
                  _BenefitChip('Sports & Gym'),
                  _BenefitChip('Opticals'),
                  _BenefitChip('Dairy Needs'),
                  _BenefitChip('Water Parks'),
                  _BenefitChip('Stationery'),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                '...and many more service providers!',
                style: TextStyle(
                  color: premiumMutedTextColor,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: goldPrimaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: premiumGoldBorderColor,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discount Benefits',
                      style: TextStyle(
                        color: premiumTextColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Customers can get 2% to 30% discount by connecting directly with service providers.',
                      style: TextStyle(
                        color: premiumMutedTextColor,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'More information is available on the Echosphere App.',
                      style: TextStyle(
                        color: premiumMutedTextColor,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              _buildSectionTitle('Insurance Cover'),

              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: premiumScaffoldColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: premiumGoldBorderColor,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹1 Lakh Accidental Insurance',
                      style: TextStyle(
                        color: goldPrimaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'The company provides a ₹1 lakh accidental insurance policy free for card holders for 1 year.',
                      style: TextStyle(
                        color: premiumMutedTextColor,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'This policy will be a General Insurance Policy (Accidental Protection).',
                      style: TextStyle(
                        color: premiumMutedTextColor,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: premiumTextColor,
        fontSize: 19,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  final String title;

  const _BenefitChip(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: premiumScaffoldColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: premiumGoldBorderColor,
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: premiumTextColor,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}