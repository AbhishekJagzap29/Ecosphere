import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      body: PageView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  /// =========================
                  /// FRONT SIDE CARD
                  /// =========================
                  Container(
                    width: double.infinity,
                    height: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: goldPrimaryColor.withOpacity(0.12),
                        width: 1,
                      ),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0E0E0E),
                          Color(0xFF151515),
                          Color(0xFF1C1407),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: goldPrimaryColor.withOpacity(0.10),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                        const BoxShadow(
                          color: Colors.black54,
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          /// DESIGN
                          Positioned(
                            top: -60,
                            left: -50,
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: goldPrimaryColor.withOpacity(0.05),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: -80,
                            right: -60,
                            child: Container(
                              height: 220,
                              width: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: goldPrimaryColor.withOpacity(0.04),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// TOP TAG
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: goldPrimaryColor.withOpacity(0.10),
                                    ),
                                    child: const Text(
                                      'ADVENTURE PASS',
                                      style: TextStyle(
                                        color: goldPrimaryColor,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                /// TITLE
                                const Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        'ECHOSPHERE',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'MULTI SERVICES PVT. LTD.',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                /// BOTTOM
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'XXXXX XXXX',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 21,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.4,
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'MEMBER ID',
                                                    style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 8,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '#01254',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(width: 28),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'VALID THRU',
                                                    style: TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 8,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Text(
                                                    '09/24',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// QR
                                    Container(
                                      height: 68,
                                      width: 68,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(
                                        Icons.qr_code_2,
                                        color: Colors.black,
                                        size: 48,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// =========================
                  /// BACK SIDE CARD
                  /// =========================
                  Container(
                    width: double.infinity,
                    height: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: goldPrimaryColor.withOpacity(0.12),
                        width: 1,
                      ),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0E0E0E),
                          Color(0xFF151515),
                          Color(0xFF1C1407),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: goldPrimaryColor.withOpacity(0.10),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                        const BoxShadow(
                          color: Colors.black54,
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// BLACK STRIP
                            // Container(
                            //   height: 28,
                            //   // width: double.infinity,
                            //   width: 220,

                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10),
                            //     color: Colors.white,
                            //   ),
                            // ),

                            // const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 36,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 4),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'CARD HOLDER SIGNATURE',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: 7,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// COMPANY NAME
                            const Center(
                              child: Column(
                                children: [
                                  Text(
                                    'ECHOSPHERE',
                                    style: TextStyle(
                                      color: goldPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'MULTI SERVICES PVT. LTD.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 8,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// CONTACT INFO
                            Center(
                              child: Column(
                                children: [
                                  const Text(
                                    '8208251866 / 9272031602',
                                    style: TextStyle(
                                      color: goldPrimaryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'www.echonsk.in',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.78),
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// ADDRESS
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.03),
                              ),
                              child: Text(
                                'To avail discount info., Kindly Call on 8208251866 / 9272031602 or Mail us at echospherensk2024@gmail.com\nWeb - www.echonsk.in',
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 8,
                                  height: 1.3,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.03),
                              ),
                              child: Text(
                                'Flat No.09, Narayan Deep Housing Society, Anand Nagar, Deolali, Nashik - 422401',
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 8,
                                  height: 1.3,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            /// POWERED BY
                            Center(
                              child: Text(
                                'Powered By Echosphere',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.55),
                                  fontSize: 8,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        Padding(
  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
  child: SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: const _SchemeContentCard(),
  ),
),
        ],
      ),
    );
  }
}

class _SchemeContentCard extends StatelessWidget {
  const _SchemeContentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Center(
            child: Icon(
              Icons.workspace_premium_rounded,
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
                border: Border.all(color: premiumGoldBorderColor),
              ),
              child: const Text(
                'One Card - Many Benefits',
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
            'Only Rs.2500/- for 5 years, for the whole family..!',
            style: TextStyle(
              color: goldPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          const _SchemeSectionTitle('About The Scheme'),
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
            'For the first time, the company has launched a unique scheme. In today\'s inflation era, every middle-class family can improve their lifestyle through this scheme. This company has introduced a beneficial plan for all.',
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
          const _SchemeSectionTitle('Available Services & Benefits'),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
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
              border: Border.all(color: premiumGoldBorderColor),
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
          const _SchemeSectionTitle('Insurance Cover'),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: premiumScaffoldColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: premiumGoldBorderColor),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rs.5 Lakh Accidental Insurance',
                  style: TextStyle(
                    color: goldPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'The company provides a Rs.1 lakh accidental insurance policy free for card holders for 1 year.',
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
    );
  }
}

class _SchemeSectionTitle extends StatelessWidget {
  final String title;

  const _SchemeSectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
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
        border: Border.all(color: premiumGoldBorderColor),
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
