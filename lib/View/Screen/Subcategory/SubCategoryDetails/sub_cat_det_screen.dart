import 'dart:convert';
import 'dart:typed_data';
import 'package:echosphere/Api/ResponseModel/taluka_response_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:echosphere/Api/ResponseModel/service_detail_response_model.dart';
import 'package:echosphere/View/Constant/app_string.dart';
import 'package:echosphere/View/Controller/service_detail_controller.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Controller/taluka_controller.dart';
import 'package:echosphere/View/Widgets/taluka_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      Get.put(ServiceDetailController());
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

  Future<void> _refreshServiceDetails() =>
      serviceDetailController.getServiceDetails(
        subserviceId: widget.subserviceId,
        talukaId: _selectedTalukaId,
      );

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
    final discount = double.tryParse(detail.discount ?? '');
    final discounts = detail.discounts;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: premiumGoldBorderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailGallery(
              image: detail.image,
              galleryImages: detail.galleryImages,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: premiumTextColor,
              ),
            ),
            const SizedBox(height: 10),
            if (detail.owner_id != null)
              _DetailRow(
                icon: Icons.badge_outlined,
                text: 'Owner : ${detail.owner_id!}',
              ),
            if (detail.address != null)
              _DetailRow(
                icon: Icons.location_on_outlined,
                text: detail.address!,
              ),
            if (detail.phone != null)
              _PhoneRow(
                phone: detail.phone!,
              ),
            if (detail.facilities.isNotEmpty)
              _DetailRow(
                icon: Icons.check_circle_outline,
                text: 'Facilities : ${detail.facilities.join(', ')}',
              ),
            if (discounts.isNotEmpty)
              _DetailRow(
                icon: Icons.local_offer_outlined,
                text: 'Discounts : ${discounts.join(', ')}',
              )
            else if (discount != null)
              _DetailRow(
                icon: Icons.local_offer_outlined,
                text: '${discount.toInt()}% Discount',
              ),
            _SocialLinksRow(detail: detail),
          ],
        ),
      ),
    );
  }
}

class _DetailGallery extends StatelessWidget {
  final String? image;
  final List<String> galleryImages;

  const _DetailGallery({
    required this.image,
    required this.galleryImages,
  });

  @override
  Widget build(BuildContext context) {
    final images = [
      ...galleryImages,
      if (galleryImages.isEmpty && image != null) image!,
    ].map(_decodeImage).whereType<Uint8List>().toList();

    if (images.isEmpty) return const SizedBox.shrink();

    if (images.length == 1) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _GalleryImage(imageBytes: images.first),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        height: 160,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (context, index) {
            return SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.62,
              child: _GalleryImage(imageBytes: images[index]),
            );
          },
        ),
      ),
    );
  }

  Uint8List? _decodeImage(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      final imageData = value.contains(',') ? value.split(',').last : value;
      return base64Decode(imageData);
    } catch (_) {
      return null;
    }
  }
}

class _GalleryImage extends StatelessWidget {
  final Uint8List imageBytes;

  const _GalleryImage({
    required this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        imageBytes,
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        gaplessPlayback: true,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: primaryGreenColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLinksRow extends StatelessWidget {
  final ServiceDetailData detail;

  const _SocialLinksRow({
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final links = <_SocialLink>[
      if (detail.youtubeLink != null)
        _SocialLink(
          label: 'YouTube',
          icon: Icons.play_circle_outline,
          url: detail.youtubeLink!,
        ),
      if (detail.facebookLink != null)
        _SocialLink(
          label: 'Facebook',
          icon: Icons.facebook,
          url: detail.facebookLink!,
        ),
      if (detail.instagramLink != null)
        _SocialLink(
          label: 'Instagram',
          icon: Icons.camera_alt_outlined,
          url: detail.instagramLink!,
        ),
    ];

    if (links.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: links
            .map(
              (link) => _SocialLinkButton(link: link),
            )
            .toList(),
      ),
    );
  }
}

class _SocialLink {
  final String label;
  final IconData icon;
  final String url;

  const _SocialLink({
    required this.label,
    required this.icon,
    required this.url,
  });
}

class _SocialLinkButton extends StatelessWidget {
  final _SocialLink link;

  const _SocialLinkButton({
    required this.link,
  });

  Future<void> _openLink() async {
    final uri = _parseUrl(link.url);

    if (uri == null) {
      debugPrint("Invalid URL");
      return;
    }

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  Uri? _parseUrl(String value) {
    final trimmedUrl = value.trim();
    if (trimmedUrl.isEmpty) return null;

    final normalizedUrl = trimmedUrl.startsWith(RegExp(r'https?://'))
        ? trimmedUrl
        : 'https://$trimmedUrl';

    return Uri.tryParse(normalizedUrl);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openLink,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: primaryGreenOverlay12Color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: premiumGoldBorderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              link.icon,
              size: 17,
              color: primaryGreenColor,
            ),
            const SizedBox(width: 6),
            Text(
              link.label,
              style: const TextStyle(
                color: premiumTextColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneRow extends StatelessWidget {
  final String phone;

  const _PhoneRow({
    required this.phone,
  });

  Future<void> _makePhoneCall() async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _makePhoneCall,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.call_outlined,
              size: 18,
              color: primaryGreenColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                phone,
                style: const TextStyle(
                  height: 1.35,
                  color: blueColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
