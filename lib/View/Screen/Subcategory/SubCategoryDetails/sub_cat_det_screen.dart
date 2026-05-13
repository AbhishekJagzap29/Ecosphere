import 'dart:convert';
import 'dart:typed_data';
import 'package:url_launcher/url_launcher.dart';
import 'package:echosphere/Api/ResponseModel/service_detail_response_model.dart';
import 'package:echosphere/View/Constant/app_string.dart';
import 'package:echosphere/View/Controller/service_detail_controller.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceDetailScreen extends StatefulWidget {
  final int? subserviceId;
  final String? subserviceName;

  const ServiceDetailScreen({
    super.key,
    this.subserviceId,
    this.subserviceName,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final ServiceDetailController serviceDetailController =
      Get.put(ServiceDetailController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceDetailController.getServiceDetails(
        subserviceId: widget.subserviceId,
      );
    });
  }

  Future<void> _refreshServiceDetails() =>
      serviceDetailController.getServiceDetails(
        subserviceId: widget.subserviceId,
      );

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
      body: GetBuilder<ServiceDetailController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: primaryGreenColor,
              ),
            );
          }

          if (controller.serviceDetails.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refreshServiceDetails,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
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
              padding: const EdgeInsets.all(16),
              itemCount: controller.serviceDetails.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final detail = controller.serviceDetails[index];

                return _ServiceDetailCard(detail: detail);
              },
            ),
          );
        },
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
            _DetailImage(image: detail.image),
            Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: premiumTextColor,
              ),
            ),
            const SizedBox(height: 10),
            if (detail.address != null)
              _DetailRow(
                icon: Icons.location_on_outlined,
                text: detail.address!,
              ),
            if (detail.phone != null)
              _PhoneRow(
                phone: detail.phone!,
              ),
            if (discount != null)
              _DetailRow(
                icon: Icons.local_offer_outlined,
                text: '${discount.toInt()}% Discount',
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailImage extends StatelessWidget {
  final String? image;

  const _DetailImage({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final imageBytes = _decodeImage(image);
    if (imageBytes == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.memory(
          imageBytes,
          width: double.infinity,
          height: 160,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      ),
    );
  }

  Uint8List? _decodeImage(String? value) {
    if (value == null || value.isEmpty) return null;

    try {
      return base64Decode(value);
    } catch (_) {
      return null;
    }
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
