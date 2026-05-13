import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:echosphere/Api/ResponseModel/service_response_model.dart';
import 'package:echosphere/Api/Services/base_service.dart';
import 'package:echosphere/View/Controller/service_controller.dart';
import 'package:echosphere/View/Screen/Category/main_cat_screen.dart';
import 'package:echosphere/View/Screen/Subcategory/sub_cat_screen.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:echosphere/View/Widgets/custom_bottom_bar.dart';
//import 'package:echosphere/View/Screen/BottomBarScreen/service_screen.dart';
// import 'package:echosphere/View/Screen/BottomBarScreen/service_detail_screen.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/profile.dart';
import 'package:echosphere/View/Screen/BottomBarScreen/about_screen.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    ServiceScreen(),
    ProfileScreen(),
    AboutScreen(),
  ];

  final List<String> _titles = const [
    "Echosphere",
    "Services",
    "Plans",
    "About",
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [luxuryBlackColor, luxuryBlackAltColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final PageController _pageController;
  late final ServiceController _serviceController;
  int _currentPage = 0;
  Timer? _timer;

  List<_HomeCategory> popularCategories = [];
  List<_HomeCategory> exploreCategories = [];

  Future<void> fetchCategories() async {
    await _serviceController.getHomeServices();
  }

  List<_HomeCategory> _buildHomeCategories(List<ServiceData> services) {
    final categories = <_HomeCategory>[];
    final usedIds = <int>{};
    final usedNames = <String>{};

    for (final service in services) {
      final name = service.name?.trim();
      if (name == null || name.isEmpty) continue;

      final serviceId = service.id;
      final normalizedName = _normalizeCategoryName(name);
      if (serviceId != null && !usedIds.add(serviceId)) continue;
      if (serviceId == null && !usedNames.add(normalizedName)) continue;

      categories.add(
        _HomeCategory(
          id: serviceId,
          name: name,
          image: service.image,
        ),
      );
    }

    return categories;
  }

  List<_HomeCategory> get sliderCategories => popularCategories;

  @override
  void initState() {
    super.initState();
    _serviceController = Get.isRegistered<ServiceController>()
        ? Get.find<ServiceController>()
        : Get.put(ServiceController());
    _pageController = PageController(viewportFraction: 0.85);
    fetchCategories();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && sliderCategories.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= sliderCategories.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      builder: (controller) {
        popularCategories = _buildHomeCategories(controller.popularServices);
        exploreCategories = _buildHomeCategories(controller.exploreServices);

        if (controller.isHomeLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: primaryGreenColor,
            ),
          );
        }

        if (popularCategories.isEmpty && exploreCategories.isEmpty) {
          return RefreshIndicator(
            onRefresh: fetchCategories,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 180),
                Icon(
                  controller.homeErrorMessage == null
                      ? Icons.category_outlined
                      : Icons.refresh,
                  color: primaryGreenColor,
                  size: 42,
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    controller.homeErrorMessage == null
                        ? 'No categories found'
                        : 'Unable to load categories',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: fetchCategories,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: fetchCategories,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sliderCategories.isNotEmpty) ...[
                    const _SectionHeader(
                      title: "Popular Categories",
                      subtitle: "Curated services people book most",
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 210,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: sliderCategories.length,
                        itemBuilder: (context, index) {
                          final category = sliderCategories[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: GestureDetector(
                              onTap: () => _openService(context, category),
                              child: _HomeCategoryCard(
                                category: category,
                                borderRadius: 20,
                                titleStyle: const TextStyle(
                                  color: whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                titleBottom: 20,
                                titleLeft: 20,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                  if (exploreCategories.isNotEmpty) ...[
                    const _SectionHeader(
                      title: "Explore More",
                      subtitle: "Find the right local expert faster",
                    ),
                    const SizedBox(height: 15),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: exploreCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final item = exploreCategories[index];

                        return GestureDetector(
                          onTap: () => _openService(context, item),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: premiumGoldBorderColor),
                              boxShadow: const [
                                BoxShadow(
                                  color: premiumShadowColor,
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                                BoxShadow(
                                  color: premiumGoldShadowColor,
                                  blurRadius: 16,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: _HomeCategoryCard(
                              category: item,
                              borderRadius: 18,
                              titleStyle: const TextStyle(
                                color: whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              titleBottom: 10,
                              titleLeft: 10,
                              titleRight: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openService(BuildContext context, _HomeCategory category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubServiceScreen(
          serviceId: category.id,
          serviceName: category.name,
        ),
      ),
    );
  }

  String _normalizeCategoryName(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }
}

class _HomeCategory {
  final int? id;
  final String name;
  final String? image;

  const _HomeCategory({
    this.id,
    required this.name,
    this.image,
  });
}

class _HomeCategoryCard extends StatelessWidget {
  final _HomeCategory category;
  final double borderRadius;
  final TextStyle titleStyle;
  final double titleBottom;
  final double titleLeft;
  final double? titleRight;

  const _HomeCategoryCard({
    required this.category,
    required this.borderRadius,
    required this.titleStyle,
    required this.titleBottom,
    required this.titleLeft,
    this.titleRight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          Positioned.fill(
            child: _HomeCategoryImage(
              image: category.image,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    blackOverlay70Color,
                    blackOverlay20Color,
                    transparentColor,
                  ],
                  stops: [0, 0.48, 1],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: titleBottom,
            left: titleLeft,
            right: titleRight,
            child: Text(
              category.name,
              style: titleStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: premiumTextColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 13.5,
            height: 1.25,
            color: premiumMutedTextColor,
          ),
        ),
      ],
    );
  }
}

class _HomeCategoryImage extends StatelessWidget {
  final String? image;

  const _HomeCategoryImage({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final imageBytes = _decodeImage(image);
    if (imageBytes != null) {
      return Image.memory(
        imageBytes,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    final imageUrl = _imageUrl(image);
    if (imageUrl != null) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _HomeImagePlaceholder(),
      );
    }

    return const _HomeImagePlaceholder();
  }

  String? _imageUrl(String? value) {
    final imageValue = value?.trim();
    if (imageValue == null || imageValue.isEmpty) return null;

    if (imageValue.startsWith('http://') || imageValue.startsWith('https://')) {
      return imageValue;
    }

    if (imageValue.startsWith('/web/') || imageValue.startsWith('/api/')) {
      return '${ApiRouts.base}$imageValue';
    }

    return null;
  }

  Uint8List? _decodeImage(String? value) {
    final imageValue = value?.trim();
    if (imageValue == null || imageValue.isEmpty) return null;

    final rawBase64Value = imageValue.contains(',')
        ? imageValue.substring(imageValue.indexOf(',') + 1)
        : imageValue;
    final base64Value = rawBase64Value.replaceAll(RegExp(r'\s+'), '');

    try {
      return base64Decode(base64Value);
    } catch (_) {
      return null;
    }
  }
}

class _HomeImagePlaceholder extends StatelessWidget {
  const _HomeImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ecoImagePlaceholderColor,
      child: const Icon(
        Icons.image_outlined,
        color: goldPrimaryColor,
        size: 42,
      ),
    );
  }
}
