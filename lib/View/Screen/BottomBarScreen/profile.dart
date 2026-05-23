import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final PageController _controller = PageController(viewportFraction: 0.94);
  int _currentPage = 0;

  late final List<Widget> _pages = [
    const _AdventurePassCardPage(),
    const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: _MarathiSchemeContentCard(),
    ),
    const SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: _SchemeContentCard(),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      body: Stack(
        children: [
          const _ProfileBackgroundGlow(),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _ProfilePageFrame(
                      isActive: _currentPage == index,
                      child: _pages[index],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _controller,
                count: _pages.length,
                effect: const WormEffect(
                  dotColor: premiumBorderColor,
                  activeDotColor: goldPrimaryColor,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 8,
                ),
              ),
              const SizedBox(height: 26),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfilePageFrame extends StatelessWidget {
  final Widget child;
  final bool isActive;

  const _ProfilePageFrame({
    required this.child,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()..scale(isActive ? 1.0 : 0.965),
      margin: EdgeInsets.fromLTRB(
        8,
        isActive ? 20 : 34,
        8,
        isActive ? 16 : 30,
      ),
      child: child,
    );
  }
}

class _AdventurePassCardPage extends StatelessWidget {
  const _AdventurePassCardPage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: const Color(0xFFD4A017),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: premiumShadowColor,
            blurRadius: 20,
            offset: Offset(0, 16),
          ),
          BoxShadow(
            color: premiumGoldShadowColor,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          // padding: const EdgeInsets.all(24),
          padding: const EdgeInsets.symmetric(
  horizontal: 18,
  vertical: 20,
),
          child: Column(
            children: [
              // TOP TITLE
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         height: 2,
              //         color: const Color(0xFFD4A017),
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     const Text(
              //       'ADVENTURE PASS',
              //       style: TextStyle(
              //         color: Color(0xFFD4A017),
              //         fontSize: 28,
              //         fontWeight: FontWeight.w900,
              //         letterSpacing: 1,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: Container(
              //         height: 2,
              //         color: const Color(0xFFD4A017),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
  children: [

    Expanded(
      child: Container(
        height: 1.5,
        color: const Color(0xFFD4A017),
      ),
    ),

    const SizedBox(width: 8),

    Flexible(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: const Text(
          'ADVENTURE PASS',
          maxLines: 1,
          style: TextStyle(
            color: Color(0xFFD4A017),
            fontSize: 60,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    ),

    const SizedBox(width: 8),

    Expanded(
      child: Container(
        height: 1.5,
        color: const Color(0xFFD4A017),
      ),
    ),

  ],
),

              const SizedBox(height: 40),

              // FRONT CARD
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/Front.png',
                  fit: BoxFit.contain,
                ),
              ),

              
              const SizedBox(height: 26),

              // BACK CARD
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/Back.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileBackgroundGlow extends StatelessWidget {
  const _ProfileBackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: 42,
          right: -72,
          child: _ProfileGlowSpot(size: 190, opacity: 0.08),
        ),
        Positioned(
          bottom: 84,
          left: -88,
          child: _ProfileGlowSpot(size: 220, opacity: 0.06),
        ),
      ],
    );
  }
}

class _ProfileGlowSpot extends StatelessWidget {
  final double size;
  final double opacity;

  const _ProfileGlowSpot({
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

class _CardImage extends StatelessWidget {
  final String assetPath;
  final double height;

  const _CardImage({
    required this.assetPath,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
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
        child: Image.asset(
          assetPath,
          fit: BoxFit.contain,
        ),
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
              // child: Icon(
              //   Icons.workspace_premium_rounded,
              //   color: goldPrimaryColor,
              //   size: 52,
              // ),
              ),
          // const SizedBox(height: 18),

          const SizedBox(height: 18),
          // Center(
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 16,
          //       vertical: 8,
          //     ),
          //     decoration: BoxDecoration(
          //       color: goldPrimaryColor.withOpacity(0.12),
          //       borderRadius: BorderRadius.circular(30),
          //       border: Border.all(color: premiumGoldBorderColor),
          //     ),
          //     child: const Text(
          //       'One Card - Many Benefits',
          //       style: TextStyle(
          //         color: goldPrimaryColor,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ),
          // ),
          // TOP PREMIUM GOLD BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 22,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB8860B),
                  Color(0xFFFFD700),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  size: 54,
                  color: Colors.black,
                ),
                SizedBox(height: 12),
                Text(
                  'ADVENTURE PASS',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'One Card - Many Benefits',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
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
              _BenefitChip('Daily Needs'),
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
                  'The company provides a Rs.5 lakh accidental insurance policy free for card holders for 1 year.',
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

class _MarathiSchemeContentCard extends StatelessWidget {
  const _MarathiSchemeContentCard();

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
          const SizedBox(height: 18),
          // TOP PREMIUM BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: 22,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFB8860B),
                  Color(0xFFFFD700),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  size: 54,
                  color: Colors.black,
                ),
                SizedBox(height: 12),
                Text(
                  'ADVENTURE PASS',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '१ कार्ड अनेक फायदे',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          const SizedBox(height: 26),

          const Text(
            'आम्ही घेऊन येत आहोत  तुमच्यासाठी फक्त ₹2500/- मध्ये 5 वर्षांसाठी संपूर्ण कुटुंबासाठी',
            style: TextStyle(
              color: goldPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

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
                SizedBox(height: 14),
                Text(
                  '''
१ कार्ड अनेक फायदे

ADVENTURE PASS डिस्काउंट कार्ड
''',
                  style: TextStyle(
                    color: premiumTextColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            '''
आता मिळवा आपल्या रोजच्या दैनंदिन खरेदी व सेवेत भरघोस सूट..!
''',
            style: TextStyle(
              color: premiumTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.8,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            '''
आजच्या महागाईच्या काळात सर्व सामान्य कुटुंबांना जीवन जगत असताना बचतीच्या मार्गाने आर्थिक लाभ व्हावा अशी योजना कंपनी घेऊन आलेली आहे.
''',
            style: TextStyle(
              color: premiumMutedTextColor,
              fontSize: 15,
              height: 1.9,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            '''
कंपनीने आपल्याला भरघोस फायदा व्हावा या दृष्टीने आपल्या परिसरातील सर्व सुविधायुक्त सेवा केंद्रांशी करार केलेला आहे.
''',
            style: TextStyle(
              color: premiumMutedTextColor,
              fontSize: 15,
              height: 1.9,
            ),
          ),

          const SizedBox(height: 28),

          const Text(
            'उपलब्ध सेवा',
            style: TextStyle(
              color: premiumTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),

          const Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _BenefitChip('हॉस्पिटल'),
              _BenefitChip('डायग्नोस्टिक लॅब'),
              _BenefitChip('पॅथॉलॉजीकल लॅब'),
              _BenefitChip('फॅमिली रेस्टॉरंट'),
              _BenefitChip('ॲग्रो टूरिजम'),
              _BenefitChip('मेडीकल'),
              _BenefitChip('हॉटेल्स'),
              _BenefitChip('रिसॉर्ट'),
              _BenefitChip('सुपर मार्केट'),
              _BenefitChip('ब्रँडेड कपडे'),
              _BenefitChip('ज्वेलरी'),
              _BenefitChip('पर्सनल केअर'),
              _BenefitChip('स्पोर्ट अँड जिम'),
              _BenefitChip('शेती'),
              _BenefitChip('डेली नीडस्'),
              _BenefitChip('ॲडव्हेंचर पास'),
              _BenefitChip('इमर्जन्सी सर्व्हिसेस'),
              _BenefitChip('गिफ्ट शॉप'),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            '...व इतर अनेक सर्व्हिस प्रोव्हाईडर्स',
            style: TextStyle(
              color: premiumMutedTextColor,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 30),

          // DISCOUNT CARD
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
                  'डिस्काउंट फायदे',
                  style: TextStyle(
                    color: premiumTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '''
सेवा पुरविणाऱ्या सर्व्हिस सेंटर बरोबर करार करून आपणास 2% ते 30% पर्यंत डिस्काउंट मिळवून देण्यासाठी प्रयत्न केलेला आहे.
''',
                  style: TextStyle(
                    color: premiumMutedTextColor,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          const Text(
            'INSURANCE विमा',
            style: TextStyle(
              color: premiumTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

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
                  '₹5 लाख अपघाती विमा',
                  style: TextStyle(
                    color: goldPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  '''
आम्ही आमच्या कार्ड धारकासाठी कंपनीकडून ₹5 लाख रुपयांची 1 वर्ष मुदतीची विमा पॉलिसी मोफत देत आहोत.
''',
                  style: TextStyle(
                    color: premiumMutedTextColor,
                    fontSize: 14,
                    height: 1.8,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '''
सदर पॉलिसी ही जनरल इन्शुरन्स पॉलिसी असेल.
(अपघाती संरक्षण)
''',
                  style: TextStyle(
                    color: premiumMutedTextColor,
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    height: 1.8,
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
