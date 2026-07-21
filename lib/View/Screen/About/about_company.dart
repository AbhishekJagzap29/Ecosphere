import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AboutCompanyScreen extends StatefulWidget {
  const AboutCompanyScreen({super.key});

  @override
  State<AboutCompanyScreen> createState() => _AboutCompanyScreenState();
}

class _AboutCompanyScreenState extends State<AboutCompanyScreen> with SingleTickerProviderStateMixin {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  static const List<_CompanyPage> _pages = [
    _CompanyPage(
      title: 'Founder & CEO',
      icon: Icons.workspace_premium_rounded,
      showCeoImage: true,
      showCompanyBranding: true,
      chipIcon: '👑',
      chipLabel: 'Founder',
      introduction: 'Welcome to Echosphere',
      sections: [
        _CompanySection(
          heading: 'About Us',
          paragraphs: [
            'Dear Echosphere Family Members,',
            'Echosphere Multi Services Pvt. Ltd. started on 2 Dec 2024, after completing 9 years and entering the 10th year of Sunmitra Trading and Marketing Pvt. Ltd.',
          ],
        ),
        _CompanySection(
          heading: 'Our Projects',
          bulletPoints: [
            'Adventure Pass Project: Already supports 20,000+ customers with services and financial support.',
            'Searching & Advertisement App: Upcoming app to help customers find nearby services while helping sellers and shop owners grow their businesses.',
          ],
        ),
        _CompanySection(
          heading: 'Future Goals',
          paragraphs: [
            'We aim to create more employment opportunities and reduce unemployment by generating opportunities for 3,000 to 5,000 people.',
          ],
        ),
      ],
      stats: [
        _CompanyStat(value: '20K+', label: 'Customers'),
        _CompanyStat(value: '3K-5K', label: 'Potential Jobs'),
        _CompanyStat(value: '10 Years', label: 'Experience'),
      ],
    ),
    _CompanyPage(
      title: 'Company Vision',
      icon: Icons.remove_red_eye_rounded,
      showLogo: true,
      chipIcon: '👁',
      chipLabel: 'Vision',
      introduction: 'Echosphere Multi Services Pvt. Ltd. was founded to support small business owners.',
      sections: [
        _CompanySection(
          heading: 'The Challenge',
          paragraphs: [
            'After studying the market, we understood that local businesses face financial challenges and lack proper advertising opportunities.',
          ],
        ),
        _CompanySection(
          heading: 'Our Solution',
          paragraphs: [
            'To solve this, we introduced the Discount Card concept, which gives customers discounts on daily needs while helping local businesses grow.',
          ],
        ),
        _CompanySection(
          heading: 'Key Features',
          bulletPoints: [
            '10,000+ cards distributed.',
            'Usable anywhere in Maharashtra.',
            'Valid in local markets.',
            'Daily discounts on services and products.',
          ],
          paragraphs: [
            'We are also building the "Every Service on Single Click" platform for easier access to products and services.',
          ],
        ),
      ],
      stats: [
        _CompanyStat(value: '10K+', label: 'Cards Distributed'),
      ],
    ),
    _CompanyPage(
      title: 'Company Mission',
      icon: Icons.flag_circle_rounded,
      showLogo: true,
      chipIcon: '🚀',
      chipLabel: 'Mission',
      introduction: 'Echosphere Multi Services Pvt. Ltd. was established to create earning opportunities for everyone.',
      sections: [
        _CompanySection(
          heading: 'Our Mission',
          paragraphs: [
            'Our mission is to help people generate part-time and full-time income sources through our business network.',
          ],
        ),
        _CompanySection(
          heading: 'Growth Milestones',
          bulletPoints: [
            '380 service agencies across Maharashtra.',
            '500 agents under each agency.',
            '500+ direct employments.',
            '4,000 freelancers with earning opportunities.',
            'Distribution of 11 lakh discount cards.',
          ],
        ),
        _CompanySection(
          heading: 'Financial Vision',
          paragraphs: [
            'The company plans to achieve 200 crore turnover in the next two years through future expansion and global growth.',
          ],
        ),
      ],
      stats: [
        _CompanyStat(value: '380', label: 'Service Agencies'),
        _CompanyStat(value: '500', label: 'Agents/Agency'),
        _CompanyStat(value: '11 Lakh', label: 'Cards Goal'),
        _CompanyStat(value: '₹200Cr', label: 'Turnover Goal'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _entranceController.dispose();
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
              'Journey • Vision • Mission',
              style: TextStyle(
                color: premiumMutedTextColor,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          const _BackgroundGlow(),
          Center(
            child: Opacity(
              opacity: 0.02,
              child: Image.asset(
                'assets/images/logo.png',
                width: 280,
                fit: BoxFit.contain,
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyPage {
  final String title;
  final IconData icon;
  final bool showLogo;
  final bool showCeoImage;
  final bool showCompanyBranding;
  final String chipIcon;
  final String chipLabel;
  final String introduction;
  final List<_CompanySection> sections;
  final List<_CompanyStat>? stats;

  const _CompanyPage({
    required this.title,
    required this.icon,
    this.showLogo = false,
    this.showCeoImage = false,
    this.showCompanyBranding = false,
    required this.chipIcon,
    required this.chipLabel,
    required this.introduction,
    required this.sections,
    this.stats,
  });
}

class _CompanySection {
  final String heading;
  final List<String> paragraphs;
  final List<String> bulletPoints;

  const _CompanySection({
    required this.heading,
    this.paragraphs = const [],
    this.bulletPoints = const [],
  });
}

class _CompanyStat {
  final String value;
  final String label;

  const _CompanyStat({
    required this.value,
    required this.label,
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

  Widget _buildRichText(String text) {
    const TextStyle defaultStyle = TextStyle(
      color: premiumTextColor,
      fontSize: 15.5,
      height: 1.7,
      fontWeight: FontWeight.w500,
    );

    const TextStyle highlightStyle = TextStyle(
      color: goldPrimaryColor,
      fontSize: 15.5,
      height: 1.7,
      fontWeight: FontWeight.w800,
    );

    final RegExp regExp = RegExp(
      r'(\d+\s+Dec\s+\d{4}|\d+\s+years|10th\s+year|₹?\d+\s+crore|\d+\s+lakh|\d{1,3}(?:,\d{3})*\+?|\d+)',
      caseSensitive: false,
    );

    final List<TextSpan> spans = [];
    int start = 0;

    for (final Match match in regExp.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: defaultStyle,
        ));
      }
      spans.add(TextSpan(
        text: match.group(0),
        style: highlightStyle,
      ));
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: defaultStyle,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
    );
  }

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
        boxShadow: [
          const BoxShadow(
            color: premiumShadowColor,
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
          BoxShadow(
            color: goldPrimaryColor.withOpacity(0.18),
            blurRadius: 40,
            spreadRadius: 2,
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
                  if (page.showCompanyBranding) ...[
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            height: 72,
                            width: 72,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: luxuryBlackColor,
                              border: Border.all(color: premiumGoldBorderColor),
                            ),
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.eco_rounded,
                                color: goldPrimaryColor,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'ECHOSPHERE',
                            style: TextStyle(
                              color: goldPrimaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                          const Text(
                            'MULTI SERVICES PVT. LTD.',
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const _GoldShineLine(),
                          const SizedBox(height: 10),
                          Text(
                            'Creating Opportunities Since 2024',
                            style: TextStyle(
                              color: whiteColor.withOpacity(0.6),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                  if (page.showCeoImage) ...[
                    const Align(
                      alignment: Alignment.center,
                      child: _CeoImage(),
                    ),
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Satish Patil',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Founder & Chief Executive Officer',
                        style: TextStyle(
                          color: goldPrimaryColor,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.center,
                      child: _GoldShineLine(),
                    ),
                    const SizedBox(height: 24),
                  ] else if (page.showLogo) ...[
                    const _PremiumLogo(),
                    const SizedBox(height: 16),
                  ] else ...[
                    _GoldIcon(icon: page.icon),
                    const SizedBox(height: 16),
                  ],
                  _GoldChip(icon: page.chipIcon, label: page.chipLabel),
                  const SizedBox(height: 14),
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
                  if (page.introduction.isNotEmpty) ...[
                    _buildRichText(page.introduction),
                    const SizedBox(height: 16),
                    if (page.showCompanyBranding) ...[
                      const _GoldShineLine(),
                      const SizedBox(height: 20),
                    ],
                  ],
                  if (page.stats != null && page.stats!.isNotEmpty) ...[
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: page.stats!.map((stat) => _StatCard(stat: stat)).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  ...page.sections.map((section) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: goldPrimaryColor,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                section.heading,
                                style: const TextStyle(
                                  color: goldPrimaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          for (final para in section.paragraphs) ...[
                            const SizedBox(height: 8),
                            _buildRichText(para),
                          ],
                          for (final bullet in section.bulletPoints) ...[
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(
                                    Icons.check_rounded,
                                    color: goldPrimaryColor,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(child: _buildRichText(bullet)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
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

class _GoldChip extends StatelessWidget {
  final String icon;
  final String label;

  const _GoldChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: goldPrimaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: premiumGoldBorderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: goldPrimaryColor,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final _CompanyStat stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: premiumSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: premiumGoldBorderColor),
        boxShadow: const [
          BoxShadow(
            color: premiumShadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              stat.value,
              style: const TextStyle(
                color: goldPrimaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.label,
            style: const TextStyle(
              color: premiumMutedTextColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PremiumLogo extends StatelessWidget {
  const _PremiumLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 115,
      padding: const EdgeInsets.all(8),
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
        padding: const EdgeInsets.all(10),
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
              size: 55,
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

class _CeoImage extends StatelessWidget {
  const _CeoImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 130,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: goldPrimaryColor,
        boxShadow: [
          BoxShadow(
            color: goldPrimaryColor.withOpacity(0.35),
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/Ceo.png',
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
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
