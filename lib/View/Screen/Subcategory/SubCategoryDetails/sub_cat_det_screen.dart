import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dw_echosphere_app/Api/ResponseModel/taluka_response_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/service_detail_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/app_string.dart';
import 'package:dw_echosphere_app/View/Controller/service_detail_controller.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Controller/taluka_controller.dart';
import 'package:dw_echosphere_app/View/Widgets/taluka_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Uint8List? _decodeImage(String? value) {
  if (value == null || value.isEmpty) return null;

  try {
    final imageData = value.contains(',') ? value.split(',').last : value;
    return base64Decode(imageData);
  } catch (_) {
    return null;
  }
}

class ServiceDetailScreen extends StatefulWidget {
  final int? subserviceId;
  final String? subserviceName;
  final int? talukaId;
  final String? talukaName;

  const ServiceDetailScreen({
    super.key,
    this.subserviceId,
    this.subserviceName,
    this.talukaId,
    this.talukaName,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final ServiceDetailController serviceDetailController =
      Get.isRegistered<ServiceDetailController>()
          ? Get.find<ServiceDetailController>()
          : Get.put(ServiceDetailController(), permanent: true);
  late final TalukaController talukaController;
  int? _selectedTalukaId;
  String? _selectedTalukaName;

  @override
  void initState() {
    super.initState();
    talukaController = Get.isRegistered<TalukaController>()
        ? Get.find<TalukaController>()
        : Get.put(TalukaController());
    _selectedTalukaId = widget.talukaId;
    _selectedTalukaName = widget.talukaName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (talukaController.talukas.isEmpty) {
        talukaController.getTalukas();
      }
      serviceDetailController.getServiceDetails(
        subserviceId: widget.subserviceId,
        talukaId: _selectedTalukaId,
      );
    });
  }

  Future<void> _refreshServiceDetails() {
    serviceDetailController.clearCacheKey(
      subserviceId: widget.subserviceId,
      talukaId: _selectedTalukaId,
    );
    return serviceDetailController.getServiceDetails(
      subserviceId: widget.subserviceId,
      talukaId: _selectedTalukaId,
    );
  }

  void _onTalukaChanged(TalukaData? taluka) {
    setState(() {
      _selectedTalukaId = taluka?.id;
      _selectedTalukaName = taluka?.name;
    });
    serviceDetailController.getServiceDetails(
      subserviceId: widget.subserviceId,
      talukaId: taluka?.id,
    );
  }

  List<ServiceDetailData> _filteredServiceDetails(
    List<ServiceDetailData> details,
  ) {
    if (_selectedTalukaId == null) return details;

    return details.where((detail) {
      return detail.talukaId == _selectedTalukaId;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subserviceName ?? AppString.serviceDetails),
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          children: [
            TalukaFilterDropdown(
              selectedTalukaId: _selectedTalukaId,
              onChanged: _onTalukaChanged,
              onRetry: talukaController.getTalukas,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GetBuilder<ServiceDetailController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryGreenColor,
                      ),
                    );
                  }

                  final serviceDetails = _filteredServiceDetails(
                    controller.serviceDetails,
                  );

                  if (serviceDetails.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshServiceDetails,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 160),
                          Center(
                            child: Text(AppString.noServiceDetailsFound),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshServiceDetails,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: serviceDetails.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final detail = serviceDetails[index];

                        return _ServiceDetailCard(detail: detail);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceDetailCard extends StatelessWidget {
  final ServiceDetailData detail;

  const _ServiceDetailCard({
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final name = detail.name ?? 'Unnamed record';

    return Card(
      elevation: 0,
      color: premiumSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: premiumGoldBorderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailImage(
              image: detail.image,
              galleryImages: detail.galleryImages,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: premiumTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () {
                      Get.to(() => _ModernServiceDetailScreen(detail: detail));
                    },
                    icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                    label: const Text('View Details'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernServiceDetailScreen extends StatefulWidget {
  final ServiceDetailData detail;

  const _ModernServiceDetailScreen({required this.detail});

  @override
  State<_ModernServiceDetailScreen> createState() =>
      _ModernServiceDetailScreenState();
}

class _ModernServiceDetailScreenState
    extends State<_ModernServiceDetailScreen> {
  late final PageController _imagePageController;
  late final ScrollController _scrollController;
  int _selectedImageIndex = 0;
  bool _isCollapsed = false;
  List<Uint8List> _compressedImages = [];

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _compressAllImages();
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _compressAllImages() async {
    final mainImageBytes = _decodeImage(widget.detail.image);
    final galleryList = widget.detail.galleryImages
        .map(_decodeImage)
        .whereType<Uint8List>()
        .toList();

    final List<Uint8List> rawImages = [
      if (mainImageBytes != null) mainImageBytes,
      ...galleryList,
    ];

    final List<Uint8List> compressed = [];
    for (final bytes in rawImages) {
      try {
        final comp = await FlutterImageCompress.compressWithList(
          bytes,
          quality: 75,
          minWidth: 1200,
          minHeight: 1200,
        );
        compressed.add(comp);
      } catch (_) {
        compressed.add(bytes);
      }
    }

    if (mounted) {
      setState(() {
        _compressedImages = compressed;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      final collapsed = _scrollController.offset >
          (280.0 - kToolbarHeight - MediaQuery.of(context).padding.top);
      if (collapsed != _isCollapsed) {
        setState(() {
          _isCollapsed = collapsed;
        });
      }
    }
  }

  void _selectImage(int index) {
    setState(() => _selectedImageIndex = index);
    _imagePageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.detail.name ?? 'Unnamed Business';
    final mainImageBytes = _decodeImage(widget.detail.image);
    final galleryImages = widget.detail.galleryImages
        .map(_decodeImage)
        .whereType<Uint8List>()
        .toList();
    final rawImages = [
      if (mainImageBytes != null) mainImageBytes,
      ...galleryImages,
    ];
    final images = _compressedImages.isNotEmpty ? _compressedImages : rawImages;
    final discount = double.tryParse(widget.detail.discount ?? '');
    final discountText = widget.detail.discounts.isNotEmpty
        ? widget.detail.discounts.join(', ')
        : discount == null
            ? null
            : '${discount.toInt()}% OFF';

    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 280.0,
            pinned: true,
            stretch: true,
            backgroundColor: luxuryBlackColor,
            elevation: 0,
            leading: Center(
              child: Container(
                margin: const EdgeInsets.only(left: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.48),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: goldPrimaryColor),
                  onPressed: Get.back,
                ),
              ),
            ),
            title: AnimatedOpacity(
              opacity: _isCollapsed ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textScaler: const TextScaler.linear(0.92),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _ModernCover(
                images: images,
                controller: _imagePageController,
                selectedIndex: _selectedImageIndex,
                onPageChanged: (index) =>
                    setState(() => _selectedImageIndex = index),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 104),
            sliver: SliverToBoxAdapter(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isTablet = constraints.maxWidth >= 720;

                  // Create the common widgets
                  final thumbsWidget = images.length > 1
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: _ModernThumbs(
                            images: images,
                            selectedIndex: _selectedImageIndex,
                            onSelected: _selectImage,
                          ),
                        )
                      : const SizedBox.shrink();

                  final nameWidget = Text(
                    name,
                    style: const TextStyle(
                      color: premiumTextColor,
                      fontSize: 28,
                      height: 1.18,
                      fontWeight: FontWeight.w700,
                    ),
                  );


                  final infoCardWidget = _ModernInfoCard(detail: widget.detail);

                  // Extract discounts list
                  final List<String> discountItems = [];
                  if (widget.detail.discounts.isNotEmpty) {
                    discountItems.addAll(widget.detail.discounts);
                  } else if (discount != null) {
                    discountItems.add('${discount.toInt()}% OFF');
                  }

                  final offersWidget = discountItems.isNotEmpty
                      ? _ModernOffer(discounts: discountItems)
                      : const SizedBox.shrink();

                  final facilitiesWidget = widget.detail.facilities.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Facilities",
                              style: TextStyle(
                                color: goldPrimaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _ModernChips(values: widget.detail.facilities),
                          ],
                        )
                      : const SizedBox.shrink();

                  if (isTablet) {
                    // Two-column layout for tablet
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        thumbsWidget,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column (Business Name, Info Card)
                            Expanded(
                              flex: 11,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  nameWidget,
                                  const SizedBox(height: 24),
                                  infoCardWidget,
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            // Right Column (Offers, Facilities)
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (discountItems.isNotEmpty) ...[
                                    offersWidget,
                                    if (widget.detail.facilities.isNotEmpty)
                                      const SizedBox(height: 32),
                                  ],
                                  facilitiesWidget,
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    // One-column layout for mobile
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        thumbsWidget,
                        nameWidget,
                        const SizedBox(height: 24),
                        infoCardWidget,
                        if (discountItems.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          offersWidget,
                        ],
                        if (widget.detail.facilities.isNotEmpty) ...[
                          const SizedBox(height: 32),
                          facilitiesWidget,
                        ],
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ModernBottomBar(detail: widget.detail),
    );
  }
}

class _ModernCover extends StatelessWidget {
  final List<Uint8List> images;
  final PageController controller;
  final int selectedIndex;
  final ValueChanged<int> onPageChanged;

  const _ModernCover({
    required this.images,
    required this.controller,
    required this.selectedIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: premiumSurfaceColor,
      child: images.isEmpty
          ? const Center(
              child: Icon(Icons.image_outlined,
                  color: premiumMutedTextColor, size: 54),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: controller,
                  physics: const BouncingScrollPhysics(),
                  itemCount: images.length,
                  onPageChanged: onPageChanged,
                  itemBuilder: (context, index) {
                    final heroTag = index == 0 && images.isNotEmpty
                        ? 'hero-main-${images[0].hashCode}'
                        : 'modern-cover-gallery-$index';

                    return GestureDetector(
                      onTap: () => Get.to(
                        () => FullScreenImage(
                          images: images,
                          initialIndex: selectedIndex,
                          heroTags: List.generate(
                            images.length,
                            (imageIndex) => imageIndex == 0
                                ? 'hero-main-${images[0].hashCode}'
                                : 'modern-cover-gallery-$imageIndex',
                          ),
                        ),
                      ),
                      child: Hero(
                        tag: heroTag,
                        child: Image.memory(
                          images[index],
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        ),
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.55),
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black.withOpacity(0.62),
                          ],
                          stops: const [0.0, 0.22, 0.65, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 18,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(images.length, (index) {
                      final isSelected = index == selectedIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isSelected ? 18 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? goldPrimaryColor
                              : Colors.white.withOpacity(0.72),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ModernThumbs extends StatelessWidget {
  final List<Uint8List> images;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ModernThumbs({
    required this.images,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final visible = images.take(5).toList();

    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: visible.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final remaining = images.length - index - 1;
          final showMore = index == visible.length - 1 && remaining > 0;

          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedScale(
              scale: isSelected ? 1.08 : 1,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: Container(
                width: 110,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? goldPrimaryColor : transparentColor,
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        visible[index],
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                      if (showMore)
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              color: Colors.black.withOpacity(0.56),
                              alignment: Alignment.center,
                              child: Text(
                                '+$remaining\nPhotos',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  height: 1.15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModernRatingRow extends StatelessWidget {
  final String category;

  const _ModernRatingRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: goldPrimaryColor.withOpacity(0.35),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Colors.white, size: 18),
              SizedBox(width: 5),
              Text('',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        const Flexible(
          child: Text(
            '',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: premiumMutedTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w600),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('•',
              style: TextStyle(color: premiumMutedTextColor, fontSize: 18)),
        ),
        Flexible(
          child: Text(
            category,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: goldPrimaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _ModernActionRow extends StatelessWidget {
  final String? phone;
  final String? address;

  const _ModernActionRow({this.phone, this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (phone != null) ...[
          Expanded(
            child: _ActionSquareButton(
              icon: Icons.phone_outlined,
              label: "Call",
              onTap: () => _makePhoneCall(phone!),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ActionSquareButton(
              icon: Icons.chat_outlined,
              label: "WhatsApp",
              onTap: () => _openWhatsApp(phone!),
            ),
          ),
        ],
        if (address != null) ...[
          if (phone != null) const SizedBox(width: 10),
          Expanded(
            child: _ActionSquareButton(
              icon: Icons.location_on_outlined,
              label: "Directions",
              onTap: () => _openMap(address!),
            ),
          ),
        ],
      ],
    );
  }
}

class _ActionSquareButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionSquareButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: goldPrimaryColor, size: 18),
        label: Text(
          label,
          style: const TextStyle(
            color: goldPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: goldPrimaryColor.withOpacity(0.4), width: 1.2),
          backgroundColor: goldPrimaryColor.withOpacity(0.06),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ModernInfoCard extends StatelessWidget {
  final ServiceDetailData detail;

  const _ModernInfoCard({required this.detail});

  @override
  Widget build(BuildContext context) {
    final hasSocials = (detail.youtubeLink != null && detail.youtubeLink!.isNotEmpty) ||
                       (detail.facebookLink != null && detail.facebookLink!.isNotEmpty) ||
                       (detail.instagramLink != null && detail.instagramLink!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Business Information",
          style: TextStyle(
            color: goldPrimaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: premiumSurfaceColor.withOpacity(0.45),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: premiumBorderColor.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (detail.owner_id != null) ...[
                _ModernInfoField(
                  icon: Icons.person_outline_rounded,
                  label: "Owner",
                  value: detail.owner_id!,
                ),
              ],
              if (detail.address != null) ...[
                if (detail.owner_id != null) const SizedBox(height: 20),
                _ModernInfoField(
                  icon: Icons.location_on_outlined,
                  label: "Address",
                  value: detail.address!,
                ),
              ],
              if (detail.phone != null) ...[
                if (detail.owner_id != null || detail.address != null)
                  const SizedBox(height: 20),
                _ModernInfoField(
                  icon: Icons.phone_outlined,
                  label: "Phone",
                  value: detail.phone!,
                ),
              ],
              if (hasSocials) ...[
                const SizedBox(height: 24),
                const Divider(color: premiumBorderColor, height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      "Social Links",
                      style: TextStyle(
                        color: premiumMutedTextColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (detail.facebookLink != null &&
                            detail.facebookLink!.isNotEmpty) ...[
                          _buildSocialIcon(
                            icon: Icons.facebook_rounded,
                            color: const Color(0xFF1877F2),
                            onTap: () => _openSocialLink(detail.facebookLink!),
                          ),
                          const SizedBox(width: 10),
                        ],
                        if (detail.instagramLink != null &&
                            detail.instagramLink!.isNotEmpty) ...[
                          _buildSocialIcon(
                            icon: Icons.camera_alt_rounded,
                            color: const Color(0xFFE4405F),
                            onTap: () => _openSocialLink(detail.instagramLink!),
                          ),
                          const SizedBox(width: 10),
                        ],
                        if (detail.youtubeLink != null &&
                            detail.youtubeLink!.isNotEmpty) ...[
                          _buildSocialIcon(
                            icon: Icons.play_circle_fill_rounded,
                            color: const Color(0xFFFF0000),
                            onTap: () => _openSocialLink(detail.youtubeLink!),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class _ModernInfoField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ModernInfoField({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: goldPrimaryColor, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: premiumMutedTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: premiumTextColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModernBottomBar extends StatelessWidget {
  final ServiceDetailData detail;

  const _ModernBottomBar({required this.detail});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        decoration: const BoxDecoration(
          color: luxuryBlackColor,
          border: Border(top: BorderSide(color: premiumBorderColor)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ModernActionButton(
                icon: Icons.location_on_outlined,
                label: 'Directions',
                onTap: detail.address == null
                    ? null
                    : () => _openMap(detail.address!),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ModernActionButton(
                icon: Icons.chat_outlined,
                label: 'WhatsApp',
                filled: true,
                onTap: detail.phone == null
                    ? null
                    : () => _openWhatsApp(detail.phone!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;

  const _ModernActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return SizedBox(
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon,
            color: filled && enabled ? blackColor : goldPrimaryColor, size: 23),
        label: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: filled && enabled ? blackColor : goldPrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              filled && enabled ? goldPrimaryColor : transparentColor,
          disabledForegroundColor: premiumMutedTextColor,
          side: BorderSide(
            color: enabled ? goldPrimaryColor : premiumBorderColor,
            width: 1.4,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

class _ModernBadge extends StatelessWidget {
  final IconData? icon;
  final String text;

  const _ModernBadge({required this.text, this.icon});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.48),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: goldPrimaryColor, size: 20),
                const SizedBox(width: 8),
              ],
              Text(text,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernChips extends StatelessWidget {
  final List<String> values;

  const _ModernChips({required this.values});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: values.map((value) {
        return Chip(
          label: Text(value.trim()),
          avatar: const Icon(Icons.check_rounded, size: 16),
          backgroundColor: goldPrimaryColor.withOpacity(0.12),
          side: BorderSide(color: goldPrimaryColor.withOpacity(0.28)),
          labelStyle: const TextStyle(
            color: premiumTextColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}

class _ModernOffer extends StatelessWidget {
  final List<String> discounts;

  const _ModernOffer({required this.discounts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🎉 Offers",
          style: TextStyle(
            color: goldPrimaryColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                goldPrimaryColor.withOpacity(0.14),
                goldPrimaryColor.withOpacity(0.04),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: goldPrimaryColor.withOpacity(0.35),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...discounts.map((discount) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(
                            Icons.fiber_manual_record,
                            color: goldPrimaryColor,
                            size: 8,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            discount,
                            style: const TextStyle(
                              color: goldPrimaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 8),
              const Text(
                "Valid for Echosphere members",
                style: TextStyle(
                  color: premiumMutedTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FullServiceDetailScreen extends StatelessWidget {
  final ServiceDetailData detail;

  const _FullServiceDetailScreen({
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final name = detail.name ?? 'Unnamed Business';
    final discount = double.tryParse(detail.discount ?? '');
    final discounts = detail.discounts;

    final mainImageBytes = _decodeImage(detail.image);
    final galleryList = [
      ...detail.galleryImages,
    ].map(_decodeImage).whereType<Uint8List>().toList();

    final List<Uint8List> allGalleryImages = [
      if (mainImageBytes != null) mainImageBytes,
      ...galleryList,
    ];

    final coverImageBytes =
        allGalleryImages.isNotEmpty ? allGalleryImages.first : null;
    const coverHeroTag = 'hero-detail-cover';

    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      appBar: AppBar(
        title: Text(name),
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
      body: Stack(
        children: [
          // Background glow
          const Positioned(
            top: 40,
            right: -80,
            child: _DetailGlowSpot(size: 200, opacity: 0.08),
          ),
          const Positioned(
            bottom: 60,
            left: -80,
            child: _DetailGlowSpot(size: 220, opacity: 0.06),
          ),
          ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              // Large Cover Image (16:9 Aspect Ratio)
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: premiumGoldBorderColor.withOpacity(0.5)),
                      color: premiumSurfaceColor,
                    ),
                    child: coverImageBytes != null
                        ? GestureDetector(
                            onTap: () {
                              Get.to(
                                () => FullScreenImage(
                                  images: allGalleryImages,
                                  initialIndex: 0,
                                  heroTags: [
                                    coverHeroTag,
                                    for (var i = 1;
                                        i < allGalleryImages.length;
                                        i++)
                                      'hero-detail-fullscreen-$i',
                                  ],
                                ),
                              );
                            },
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Hero(
                                  tag: coverHeroTag,
                                  child: Image.memory(
                                    coverImageBytes,
                                    fit: BoxFit.cover,
                                    gaplessPlayback: true,
                                  ),
                                ),
                                if (allGalleryImages.length > 1)
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.65),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: premiumGoldBorderColor
                                                .withOpacity(0.5)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.camera_alt_outlined,
                                              color: goldPrimaryColor,
                                              size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${allGalleryImages.length}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_outlined,
                              color: premiumMutedTextColor,
                              size: 48,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Gallery Thumbnails
              if (allGalleryImages.length > 1) ...[
                _DetailGallery(images: allGalleryImages),
                const SizedBox(height: 20),
              ],

              // Business Name
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: premiumTextColor,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return const Icon(
                    Icons.star_rounded,
                    color: goldPrimaryColor,
                    size: 20,
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Business Information
              const Text(
                "Business Information",
                style: TextStyle(
                  color: goldPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: premiumSurfaceColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: premiumGoldBorderColor.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (detail.owner_id != null) ...[
                      _buildInfoItem(
                        icon: Icons.person_outline_rounded,
                        label: "Owner",
                        value: detail.owner_id!,
                      ),
                      const Divider(color: premiumBorderColor, height: 24),
                    ],
                    if (detail.address != null) ...[
                      _buildInfoItem(
                        icon: Icons.location_on_outlined,
                        label: "Address",
                        value: detail.address!,
                      ),
                      const Divider(color: premiumBorderColor, height: 24),
                    ],
                    if (detail.phone != null) ...[
                      _buildInfoItem(
                        icon: Icons.phone_outlined,
                        label: "Phone",
                        value: detail.phone!,
                        isPhone: true,
                      ),
                    ],
                  ],
                ),
              ),

              // Facilities
              if (detail.facilities.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Text(
                  "Facilities",
                  style: TextStyle(
                    color: goldPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: detail.facilities.map((fac) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryGreenColor.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: primaryGreenColor.withOpacity(0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_rounded,
                              color: primaryGreenColor, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            fac.trim(),
                            style: const TextStyle(
                              color: premiumTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              // Discount
              if (discounts.isNotEmpty || discount != null) ...[
                const SizedBox(height: 24),
                const Text(
                  "Exclusive Discount",
                  style: TextStyle(
                    color: goldPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        goldPrimaryColor.withOpacity(0.12),
                        goldPrimaryColor.withOpacity(0.02)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: goldPrimaryColor.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text("🎉", style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              discounts.isNotEmpty
                                  ? discounts.join(', ')
                                  : '${discount!.toInt()}% OFF',
                              style: const TextStyle(
                                color: goldPrimaryColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Show this screen to claim your offer!",
                              style: TextStyle(
                                color: premiumMutedTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Social Connections
              const SizedBox(height: 24),
              const Text(
                "Social Connections",
                style: TextStyle(
                  color: goldPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  if (detail.youtubeLink != null &&
                      detail.youtubeLink!.isNotEmpty)
                    _CircularActionButton(
                      icon: Icons.play_circle_fill_rounded,
                      iconColor: Colors.red,
                      label: "YouTube",
                      onTap: () => _openSocialLink(detail.youtubeLink!),
                    ),
                  if (detail.facebookLink != null &&
                      detail.facebookLink!.isNotEmpty)
                    _CircularActionButton(
                      icon: Icons.facebook_rounded,
                      iconColor: Colors.blueAccent,
                      label: "Facebook",
                      onTap: () => _openSocialLink(detail.facebookLink!),
                    ),
                  if (detail.instagramLink != null &&
                      detail.instagramLink!.isNotEmpty)
                    _CircularActionButton(
                      icon: Icons.camera_alt_rounded,
                      iconColor: Colors.pinkAccent,
                      label: "Instagram",
                      onTap: () => _openSocialLink(detail.instagramLink!),
                    ),
                  if (detail.phone != null)
                    _CircularActionButton(
                      icon: Icons.call,
                      iconColor: primaryGreenColor,
                      label: "Call",
                      onTap: () => _makePhoneCall(detail.phone!),
                    ),
                  if (detail.address != null)
                    _CircularActionButton(
                      icon: Icons.map_outlined,
                      iconColor: goldPrimaryColor,
                      label: "Map",
                      onTap: () => _openMap(detail.address!),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isPhone = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryGreenColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: premiumMutedTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              isPhone
                  ? GestureDetector(
                      onTap: () => _makePhoneCall(value),
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: blueColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        color: premiumTextColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailImage extends StatelessWidget {
  final String? image;
  final List<String> galleryImages;

  const _DetailImage({
    required this.image,
    required this.galleryImages,
  });

  Future<Uint8List> _compressBytes(Uint8List bytes) async {
    try {
      return await FlutterImageCompress.compressWithList(
        bytes,
        quality: 75,
        minWidth: 800,
        minHeight: 450,
      );
    } catch (_) {
      return bytes;
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = galleryImages.isNotEmpty ? galleryImages.first : image;
    final imageBytes = _decodeImage(displayImage);
    final heroTag =
        imageBytes != null ? 'hero-main-${imageBytes.hashCode}' : null;

    final images = [
      ...galleryImages,
      if (galleryImages.isEmpty && image != null) image!,
    ].map(_decodeImage).whereType<Uint8List>().toList();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: imageBytes != null
          ? FutureBuilder<Uint8List>(
              future: _compressBytes(imageBytes),
              builder: (context, snapshot) {
                final displayBytes = snapshot.data ?? imageBytes;
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => FullScreenImage(
                        images: images,
                        initialIndex: 0,
                        heroTags: [
                          heroTag,
                          for (var i = 1; i < images.length; i++)
                            'hero-main-fullscreen-$i',
                        ],
                      ),
                    );
                  },
                  child: Hero(
                    tag: heroTag!,
                    child: Image.memory(
                      displayBytes,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                  ),
                );
              },
            )
          : Container(
              color: premiumBorderColor.withOpacity(0.1),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  color: premiumMutedTextColor,
                  size: 40,
                ),
              ),
            ),
    );
  }
}

class _DetailGallery extends StatelessWidget {
  final List<Uint8List> images;

  const _DetailGallery({
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gallery",
          style: TextStyle(
            color: goldPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final heroTag = 'hero-detail-gallery-$index';
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => FullScreenImage(
                      images: images,
                      initialIndex: index,
                      heroTags: List.generate(
                        images.length,
                        (imageIndex) => 'hero-detail-gallery-$imageIndex',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: premiumGoldBorderColor.withOpacity(0.3)),
                      ),
                      child: Image.memory(
                        images[index],
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _makePhoneCall(String phone) async {
  final Uri uri = Uri(
    scheme: 'tel',
    path: phone.trim(),
  );
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}

Future<void> _openMap(String address) async {
  final query = Uri.encodeComponent(address.trim());
  final googleMapsUrl =
      Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");
  if (await canLaunchUrl(googleMapsUrl)) {
    await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
  }
}

Future<void> _openWhatsApp(String phone) async {
  final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return;

  final whatsappUrl = Uri.parse('https://wa.me/$digits');
  if (await canLaunchUrl(whatsappUrl)) {
    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
  }
}

Future<void> _openSocialLink(String url) async {
  final trimmedUrl = url.trim();
  if (trimmedUrl.isEmpty) return;
  final normalizedUrl = trimmedUrl.startsWith(RegExp(r'https?://'))
      ? trimmedUrl
      : 'https://$trimmedUrl';
  final uri = Uri.tryParse(normalizedUrl);
  if (uri != null) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class _CircularActionButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _CircularActionButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: premiumSurfaceColor,
              border:
                  Border.all(color: premiumGoldBorderColor.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                )
              ],
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: premiumMutedTextColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DetailGlowSpot extends StatelessWidget {
  final double size;
  final double opacity;

  const _DetailGlowSpot({
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

class FullScreenImage extends StatefulWidget {
  final List<Uint8List> images;
  final int initialIndex;
  final List<dynamic> heroTags;

  const FullScreenImage({
    super.key,
    required this.images,
    required this.initialIndex,
    required this.heroTags,
  });

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${_currentIndex + 1} / ${widget.images.length}",
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: MemoryImage(widget.images[index]),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 4.1,
            heroAttributes: PhotoViewHeroAttributes(
              tag: index < widget.heroTags.length
                  ? widget.heroTags[index]
                  : 'gallery-$index',
            ),
          );
        },
        itemCount: widget.images.length,
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
