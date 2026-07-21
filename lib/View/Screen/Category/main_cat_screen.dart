import 'package:dw_echosphere_app/Api/ResponseModel/taluka_response_model.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/service_response_model.dart';
import 'package:dw_echosphere_app/View/Controller/service_controller.dart';
import 'package:dw_echosphere_app/View/Controller/taluka_controller.dart';
import 'package:dw_echosphere_app/View/Screen/Subcategory/sub_cat_screen.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Widgets/taluka_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceController serviceController =
      Get.isRegistered<ServiceController>()
          ? Get.find<ServiceController>()
          : Get.put(ServiceController());
  late final TalukaController talukaController;
  int? _selectedTalukaId;
  String? _selectedTalukaName;

  @override
  void initState() {
    super.initState();
    talukaController = Get.isRegistered<TalukaController>()
        ? Get.find<TalukaController>()
        : Get.put(TalukaController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (talukaController.talukas.isEmpty) {
        talukaController.getTalukas();
      }
      serviceController.getServices();
    });
  }

  Future<void> _refreshServices() => serviceController.getServices(
        talukaId: _selectedTalukaId,
      );

  void _onTalukaChanged(TalukaData? taluka) {
    setState(() {
      _selectedTalukaId = taluka?.id;
      _selectedTalukaName = taluka?.name;
    });
    serviceController.getServices(talukaId: taluka?.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      body: Stack(
        children: [
          const _ServiceBackgroundGlow(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Main Categories",
                        style: TextStyle(
                          color: goldPrimaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Discover trusted services near you",
                        style: TextStyle(
                          color: premiumMutedTextColor,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(height: 6),
                    ],
                  ),
                  TalukaFilterDropdown(
                    selectedTalukaId: _selectedTalukaId,
                    onChanged: _onTalukaChanged,
                    onRetry: talukaController.getTalukas,
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: GetBuilder<ServiceController>(
                      builder: (controller) {
                        if (controller.isLoading) {
                          return const _ServiceSkeletonList();
                        }

                        final services = controller.services;

                        if (services.isEmpty) {
                          return RefreshIndicator(
                            onRefresh: _refreshServices,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: const [
                                SizedBox(height: 120),
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open_rounded,
                                        size: 72,
                                        color: premiumMutedTextColor,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        "No Categories Available",
                                        style: TextStyle(
                                          color: premiumTextColor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        "Try another Taluka",
                                        style: TextStyle(
                                          color: premiumMutedTextColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 2, bottom: 6),
                              child: Row(
                                children: [
                                  Text(
                                    "${services.length} Categories",
                                    style: const TextStyle(
                                      color: goldPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: RefreshIndicator(
                                onRefresh: _refreshServices,
                                child: ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: services.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                                  itemBuilder: (context, index) {
                                    final service = services[index];
                                    final serviceName = service.name ?? 'Unnamed service';

                                    return _ServiceCategoryCard(
                                      service: service,
                                      serviceName: serviceName,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SubServiceScreen(
                                              serviceId: service.id,
                                              serviceName: serviceName,
                                              talukaId: _selectedTalukaId,
                                              talukaName: _selectedTalukaName,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCategoryCard extends StatefulWidget {
  final ServiceData service;
  final String serviceName;
  final VoidCallback onTap;

  const _ServiceCategoryCard({
    required this.service,
    required this.serviceName,
    required this.onTap,
  });

  @override
  State<_ServiceCategoryCard> createState() => _ServiceCategoryCardState();
}

class _ServiceCategoryCardState extends State<_ServiceCategoryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final serviceInitial = widget.serviceName.trim().isNotEmpty
        ? widget.serviceName.trim()[0].toUpperCase()
        : '?';

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: premiumSurfaceColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: premiumGoldBorderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: goldPrimaryColor.withOpacity(.08),
                blurRadius: 30,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: 6,
                    width: 70,
                    decoration: const BoxDecoration(
                      color: goldPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff123B2F),
                                  Color(0xff1A5D45),
                                ],
                              ),
                              border: Border.all(
                                color: premiumGoldBorderColor,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                serviceInitial,
                                style: const TextStyle(
                                  color: goldPrimaryColor,
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.serviceName.toUpperCase(),
                                  style: const TextStyle(
                                    color: premiumTextColor,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                if (widget.service.description != null &&
                                    widget.service.description!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.service.description!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: premiumMutedTextColor,
                                      fontSize: 13,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(
                          color: premiumBorderColor,
                          height: 1,
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Explore",
                            style: TextStyle(
                              color: goldPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: goldPrimaryColor,
                            size: 14,
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
      ),
    );
  }
}

class _ServiceSkeletonList extends StatelessWidget {
  const _ServiceSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: premiumSurfaceColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: premiumBorderColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: premiumBorderColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 140,
                          decoration: BoxDecoration(
                            color: premiumBorderColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 200,
                          decoration: BoxDecoration(
                            color: premiumBorderColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 1,
                color: premiumBorderColor.withOpacity(0.2),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 14,
                  width: 80,
                  decoration: BoxDecoration(
                    color: premiumBorderColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ServiceBackgroundGlow extends StatelessWidget {
  const _ServiceBackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: 42,
          right: -72,
          child: _ServiceGlowSpot(size: 190, opacity: 0.08),
        ),
        Positioned(
          bottom: 84,
          left: -88,
          child: _ServiceGlowSpot(size: 220, opacity: 0.06),
        ),
      ],
    );
  }
}

class _ServiceGlowSpot extends StatelessWidget {
  final double size;
  final double opacity;

  const _ServiceGlowSpot({
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
