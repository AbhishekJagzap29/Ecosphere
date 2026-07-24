import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dw_echosphere_app/Api/Services/base_service.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Controller/service_controller.dart';
import 'package:dw_echosphere_app/View/Screen/BottomBarScreen/about_screen.dart';
import 'package:dw_echosphere_app/View/Screen/BottomBarScreen/plans.dart';
import 'package:dw_echosphere_app/View/Screen/Category/main_cat_screen.dart';
import 'package:dw_echosphere_app/View/Screen/Subcategory/sub_cat_screen.dart';
import 'package:dw_echosphere_app/View/Widgets/custom_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Layout and animation constants for Home Screen.
abstract class _HomeConstants {
  static const double sliderHeight = 210.0;
  static const double retryPlaceholderHeight = 180.0;
  static const double retryIconSize = 42.0;
  static const double placeholderIconSize = 42.0;
  static const double categoryCardBorderRadius = 20.0;
  static const double exploreCardBorderRadius = 18.0;
  static const double sliderIndicatorSelectedWidth = 18.0;
  static const double sliderIndicatorUnselectedWidth = 6.0;
  static const double sliderIndicatorHeight = 6.0;
  static const double spacingMedium = 12.0;
  static const double spacingSectionHeader = 14.0;
  static const double spacingGrid = 15.0;
  static const double spacingExtraLarge = 28.0;
  static const double spacingSection = 30.0;
  static const Duration autoSlideDuration = Duration(seconds: 3);
  static const Duration animatePageDuration = Duration(milliseconds: 800);
  static const Duration indicatorAnimDuration = Duration(milliseconds: 260);
}

/// Bounded LRU cache for Base64 image decoding and MemoryImage instances.
abstract class _BoundedImageCache {
  static const int _maxEntries = 100;
  static final LinkedHashMap<String, MemoryImage> _memoryImageCache =
      LinkedHashMap<String, MemoryImage>();
  static final LinkedHashMap<String, Uint8List?> _bytesCache =
      LinkedHashMap<String, Uint8List?>();

  static MemoryImage? getMemoryImage(String? value) {
    final imageValue = value?.trim();
    if (imageValue == null || imageValue.isEmpty) return null;

    if (_memoryImageCache.containsKey(imageValue)) {
      final image = _memoryImageCache.remove(imageValue)!;
      _memoryImageCache[imageValue] = image;
      return image;
    }

    final bytes = _decodeBytes(imageValue);
    if (bytes == null) return null;

    final memoryImage = MemoryImage(bytes);
    if (_memoryImageCache.length >= _maxEntries) {
      _memoryImageCache.remove(_memoryImageCache.keys.first);
    }
    _memoryImageCache[imageValue] = memoryImage;
    return memoryImage;
  }

  static Uint8List? _decodeBytes(String imageValue) {
    if (_bytesCache.containsKey(imageValue)) {
      final bytes = _bytesCache.remove(imageValue);
      _bytesCache[imageValue] = bytes;
      return bytes;
    }

    final rawBase64Value = imageValue.contains(',')
        ? imageValue.substring(imageValue.indexOf(',') + 1)
        : imageValue;
    final base64Value = rawBase64Value.replaceAll(RegExp(r'\s+'), '');

    try {
      final bytes = base64Decode(base64Value);
      if (_bytesCache.length >= _maxEntries) {
        _bytesCache.remove(_bytesCache.keys.first);
      }
      _bytesCache[imageValue] = bytes;
      return bytes;
    } catch (e) {
      debugPrint('Error decoding base64 image: $e');
      if (_bytesCache.length >= _maxEntries) {
        _bytesCache.remove(_bytesCache.keys.first);
      }
      _bytesCache[imageValue] = null;
      return null;
    }
  }
}

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
    PlansScreen(),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
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

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final PageController _pageController;
  late final ServiceController _serviceController;
  int _currentPage = 0;
  Timer? _timer;

  Future<void> _fetchCategories() async {
    await _serviceController.getHomeServices();
  }

  @override
  void initState() {
    super.initState();
    _serviceController = Get.isRegistered<ServiceController>()
        ? Get.find<ServiceController>()
        : Get.put(ServiceController());
    _pageController = PageController(viewportFraction: 1.0);
    if (_serviceController.popularServices.isEmpty &&
        _serviceController.exploreServices.isEmpty) {
      _fetchCategories();
    }
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer?.cancel();
    _timer = Timer.periodic(_HomeConstants.autoSlideDuration, (timer) {
      final sliderCategories = _serviceController.popularHomeCategories;
      if (_pageController.hasClients && sliderCategories.isNotEmpty) {
        _currentPage++;
        if (_currentPage >= sliderCategories.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: _HomeConstants.animatePageDuration,
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _pauseAutoSlide() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _pauseAutoSlide();
    _pageController.dispose();
    super.dispose();
  }

  void _openService(HomeCategory category) {
    Get.to(
      () => SubServiceScreen(
        serviceId: category.id,
        serviceName: category.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ServiceController>(
      builder: (controller) {
        if (controller.isHomeLoading) {
          return const _HomeLoadingView();
        }

        final popularCategories = controller.popularHomeCategories;
        final exploreCategories = controller.exploreHomeCategories;

        if (popularCategories.isEmpty && exploreCategories.isEmpty) {
          return _HomeEmptyView(
            errorMessage: controller.homeErrorMessage,
            onRetry: _fetchCategories,
          );
        }

        return RefreshIndicator(
          onRefresh: _fetchCategories,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (popularCategories.isNotEmpty) ...[
                    const _SectionHeader(
                      title: "Popular Categories",
                      subtitle: "Curated services people book most",
                    ),
                    const SizedBox(height: _HomeConstants.spacingSectionHeader),
                    _PopularSlider(
                      pageController: _pageController,
                      categories: popularCategories,
                      onCategoryTap: _openService,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      onScrollStart: _pauseAutoSlide,
                      onScrollEnd: _startAutoSlide,
                    ),
                    const SizedBox(height: _HomeConstants.spacingMedium),
                    _SliderIndicators(
                      itemCount: popularCategories.length,
                      currentIndex: _currentPage,
                    ),
                    const SizedBox(height: _HomeConstants.spacingExtraLarge),
                  ],
                  if (exploreCategories.isNotEmpty) ...[
                    const _SectionHeader(
                      title: "Explore More",
                      subtitle: "Find the right local expert faster",
                    ),
                    const SizedBox(height: _HomeConstants.spacingGrid),
                    _ExploreGrid(
                      categories: exploreCategories,
                      onCategoryTap: _openService,
                    ),
                  ],
                  const SizedBox(height: _HomeConstants.spacingSection),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: primaryGreenColor,
      ),
    );
  }
}

class _HomeEmptyView extends StatelessWidget {
  final String? errorMessage;
  final Future<void> Function() onRetry;

  const _HomeEmptyView({
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRetry,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: _HomeConstants.retryPlaceholderHeight),
          Icon(
            errorMessage == null ? Icons.category_outlined : Icons.refresh,
            color: primaryGreenColor,
            size: _HomeConstants.retryIconSize,
          ),
          const SizedBox(height: _HomeConstants.spacingMedium),
          Center(
            child: Text(
              errorMessage == null
                  ? 'No categories found'
                  : 'Unable to load categories',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: _HomeConstants.spacingMedium),
          Center(
            child: Semantics(
              button: true,
              label: 'Retry loading categories',
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopularSlider extends StatelessWidget {
  final PageController pageController;
  final List<HomeCategory> categories;
  final ValueChanged<HomeCategory> onCategoryTap;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onScrollStart;
  final VoidCallback onScrollEnd;

  const _PopularSlider({
    required this.pageController,
    required this.categories,
    required this.onCategoryTap,
    required this.onPageChanged,
    required this.onScrollStart,
    required this.onScrollEnd,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _HomeConstants.sliderHeight,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            onScrollStart();
          } else if (notification is ScrollEndNotification) {
            onScrollEnd();
          }
          return false;
        },
        child: PageView.builder(
          controller: pageController,
          itemCount: categories.length,
          onPageChanged: onPageChanged,
          itemBuilder: (context, index) {
            final category = categories[index];

            return Semantics(
              button: true,
              label: '${category.name} category',
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  _HomeConstants.categoryCardBorderRadius,
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  borderRadius: BorderRadius.circular(
                    _HomeConstants.categoryCardBorderRadius,
                  ),
                  onTap: () => onCategoryTap(category),
                  child: _HomeCategoryCard(
                    category: category,
                    borderRadius: _HomeConstants.categoryCardBorderRadius,
                    titleStyle: const TextStyle(
                      color: whiteColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    titleBottom: 20,
                    titleLeft: 20,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SliderIndicators extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const _SliderIndicators({
    required this.itemCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isSelected = index == currentIndex;
        return Semantics(
          label: 'Slide ${index + 1} of $itemCount',
          selected: isSelected,
          child: AnimatedContainer(
            duration: _HomeConstants.indicatorAnimDuration,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isSelected
                ? _HomeConstants.sliderIndicatorSelectedWidth
                : _HomeConstants.sliderIndicatorUnselectedWidth,
            height: _HomeConstants.sliderIndicatorHeight,
            decoration: BoxDecoration(
              color: isSelected
                  ? goldPrimaryColor
                  : Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
        );
      }),
    );
  }
}

class _ExploreGrid extends StatelessWidget {
  final List<HomeCategory> categories;
  final ValueChanged<HomeCategory> onCategoryTap;

  const _ExploreGrid({
    required this.categories,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = categories[index];

        return Semantics(
          button: true,
          label: '${item.name} category',
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(
              _HomeConstants.exploreCardBorderRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                _HomeConstants.exploreCardBorderRadius,
              ),
              onTap: () => onCategoryTap(item),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    _HomeConstants.exploreCardBorderRadius,
                  ),
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
                  borderRadius: _HomeConstants.exploreCardBorderRadius,
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
            ),
          ),
        );
      },
    );
  }
}

class _HomeCategoryCard extends StatelessWidget {
  final HomeCategory category;
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
    final memoryImage = _BoundedImageCache.getMemoryImage(image);
    if (memoryImage != null) {
      return Semantics(
        image: true,
        label: 'Category image',
        child: Image(
          image: memoryImage,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      );
    }

    final imageUrl = _imageUrl(image);
    if (imageUrl != null) {
      return Semantics(
        image: true,
        label: 'Category image',
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => const _HomeImagePlaceholder(),
          errorWidget: (context, url, error) => const _HomeImagePlaceholder(),
        ),
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
}

class _HomeImagePlaceholder extends StatelessWidget {
  const _HomeImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ecoImagePlaceholderColor,
      child: Semantics(
        image: true,
        label: 'Category image placeholder',
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            color: goldPrimaryColor,
            size: _HomeConstants.placeholderIconSize,
          ),
        ),
      ),
    );
  }
}
