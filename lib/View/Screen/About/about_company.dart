import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AboutCompanyScreen extends StatefulWidget {
  const AboutCompanyScreen({super.key});

  @override
  State<AboutCompanyScreen> createState() => _AboutCompanyScreenState();
}

class _AboutCompanyScreenState extends State<AboutCompanyScreen> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  static const List<_CompanyPage> _pages = [
    _CompanyPage(
      title: 'Founder & CEO',
      icon: Icons.workspace_premium_rounded,
      content: '''
Dear Echosphere Family Members,

Echosphere Multi Services Pvt. Ltd. started on 2 Dec 2024, after completing 9 years and entering the 10th year of Sumitra Trading and Marketing Pvt. Ltd.

We introduced two major projects:

- Adventure Pass Project
- Searching / Advertisement App

The Adventure Pass Project already supports 20,000+ customers with services and financial support.

Our upcoming Searching App will help customers easily find nearby services while helping sellers and shop owners grow their businesses.

We aim to create more employment opportunities and reduce unemployment by generating opportunities for 3,000 to 5,000 people.

Thank you for your trust and continuous support.

Satish Patil
Founder & CEO
''',
    ),
    _CompanyPage(
      title: 'Company Vision',
      icon: Icons.remove_red_eye_rounded,
      showLogo: true,
      content: '''
Echosphere Multi Services Pvt. Ltd. was founded to support small business owners.

After studying the market, we understood that local businesses face financial challenges and lack proper advertising opportunities.

To solve this, we introduced the Discount Card concept, which gives customers discounts on daily needs while helping local businesses grow.

Features:

- 10,000+ cards distributed
- Usable anywhere in Maharashtra
- Valid in local markets
- Daily discounts on services and products

We are also building the "Every Service on Single Click" platform for easier access to products and services.
''',
    ),
    _CompanyPage(
      title: 'Company Mission',
      icon: Icons.flag_circle_rounded,
      showLogo: true,
      content: '''
Echosphere Multi Services Pvt. Ltd. was established to create earning opportunities for everyone.

Our mission is to help people generate part-time and full-time income sources through our business network.

Goals:

- 380 service agencies across Maharashtra
- 500 agents under each agency
- 500+ direct employments
- 4,000 freelancers with earning opportunities
- Distribution of 11 lakh discount cards

The company plans to achieve 200 crore turnover in the next two years through future expansion and global growth.
''',
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
      appBar: AppBar(
        toolbarHeight: 74,
        title: const Column(
          children: [
            Text('About Company'),
            SizedBox(height: 3),
            Text(
              'Our Journey | Vision | Mission',
              style: TextStyle(
                color: premiumMutedTextColor,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          const _BackgroundGlow(),
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
                    return _PremiumCard(
                      page: _pages[index],
                      isActive: _currentPage == index,
                      isLastPage: index == _pages.length - 1,
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

class _CompanyPage {
  final String title;
  final String content;
  final IconData icon;
  final bool showLogo;

  const _CompanyPage({
    required this.title,
    required this.content,
    required this.icon,
    this.showLogo = false,
  });
}

class _PremiumCard extends StatelessWidget {
  final _CompanyPage page;
  final bool isActive;
  final bool isLastPage;

  const _PremiumCard({
    required this.page,
    required this.isActive,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()
  ..scale(isActive ? 1.0 : 0.965),
      margin: EdgeInsets.fromLTRB(
        8,
        isActive ? 20 : 34,
        8,
        isActive ? 16 : 30,
      ),
      decoration: BoxDecoration(
        color: whiteColor.withOpacity(0.02),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: premiumGoldBorderColor, width: 1.2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            premiumSurfaceTintColor,
            premiumSurfaceColor,
            luxuryBlackColor,
          ],
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned(
              top: -44,
              right: -34,
              child: _GoldCircle(size: 150, opacity: isActive ? 0.08 : 0.04),
            ),
            Positioned(
              bottom: -58,
              left: -38,
              child: _GoldCircle(size: 170, opacity: isActive ? 0.055 : 0.03),
            ),
                    Positioned(
                      right: -30,
                      bottom: -30,
                      child: Opacity(
                        opacity: 0.025,
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 150,
                        ),
                      ),
                    ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  page.showLogo
                      ? const _PremiumLogo()
                      : _GoldIcon(icon: page.icon),
                  const SizedBox(height: 24),
                  Text(
                    page.title,
                    style: const TextStyle(
                      color: goldPrimaryColor,
                      fontSize: 27,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _GoldShineLine(),
                  const SizedBox(height: 24),
                  Text(
                    page.content,
                    style: const TextStyle(
                      color: premiumTextColor,
                      // fontSize: 15,
                      // height: 1.72,
                      fontSize: 14.5,
                      height: 1.62,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 26),
                  if (!isLastPage) const Center(child: _SwipeHint()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumLogo extends StatelessWidget {
  const _PremiumLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 90,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [
            goldHighlightColor,
            goldPrimaryColor,
            Color(0xFF8A6614),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: premiumGoldShadowColor,
            blurRadius: 20,
            offset: Offset(0, 12),
          ),
          BoxShadow(
            color: premiumShadowColor,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: luxuryBlackColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: whiteOverlay10Color),
        ),
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.eco_rounded,
              color: goldPrimaryColor,
              size: 42,
            );
          },
        ),
      ),
    );
  }
}

class _GoldIcon extends StatelessWidget {
  final IconData icon;

  const _GoldIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      width: 76,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [goldHighlightColor, goldPrimaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: premiumGoldShadowColor,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, color: blackColor, size: 38),
    );
  }
}

class _GoldCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _GoldCircle({
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

class _GoldShineLine extends StatelessWidget {
  const _GoldShineLine();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            transparentColor,
            goldPrimaryColor,
            transparentColor,
          ],
        ).createShader(bounds);
      },
      child: Container(
        height: 3,
        width: 110,
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class _SwipeHint extends StatefulWidget {
  const _SwipeHint();

  @override
  State<_SwipeHint> createState() => _SwipeHintState();
}

class _SwipeHintState extends State<_SwipeHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.48, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: premiumGoldBorderColor),
          color: whiteColor.withOpacity(0.03),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swipe_rounded, color: goldPrimaryColor, size: 18),
            SizedBox(width: 8),
            Text(
              'Swipe for More',
              style: TextStyle(
                color: goldPrimaryColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
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
    return const Stack(
      
      children: [
        Positioned(
          top: 42,
          right: -72,
          child: _GlowSpot(size: 190, opacity: 0.08),
        ),
        Positioned(
          bottom: 84,
          left: -88,
          child: _GlowSpot(size: 220, opacity: 0.06),
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








// import 'package:echosphere/View/Constant/app_color.dart';
// import 'package:flutter/material.dart';

// class AboutCompanyScreen extends StatelessWidget {
//   const AboutCompanyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const _AboutDetailScreen(
//       title: 'About Company',
//       icon: Icons.people_alt_rounded,
//       heading: 'Echosphere Multi Services',
//       description:
//           'Echosphere connects people with trusted local services, useful updates, events, and member-first support through one simple platform.',
//     );
//   }
// }

// class _AboutDetailScreen extends StatelessWidget {
//   final String title;
//   final IconData icon;
//   final String heading;
//   final String description;

//   const _AboutDetailScreen({
//     required this.title,
//     required this.icon,
//     required this.heading,
//     required this.description,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(22),
//           decoration: BoxDecoration(
//             color: premiumSurfaceColor,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: premiumGoldBorderColor),
//             boxShadow: const [
//               BoxShadow(
//                 color: premiumShadowColor,
//                 blurRadius: 22,
//                 offset: Offset(0, 10),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(icon, color: goldPrimaryColor, size: 42),
//               const SizedBox(height: 18),
//               Text(
//                 heading,
//                 style: const TextStyle(
//                   color: premiumTextColor,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w900,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 description,
//                 style: const TextStyle(
//                   color: premiumMutedTextColor,
//                   fontSize: 14,
//                   height: 1.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
