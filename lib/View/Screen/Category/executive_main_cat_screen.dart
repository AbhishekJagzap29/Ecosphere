import 'package:dw_echosphere_app/Api/ResponseModel/service_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Constant/app_string.dart';
import 'package:dw_echosphere_app/View/Controller/service_controller.dart';
import 'package:dw_echosphere_app/View/Screen/ServiceRequest/create_service_request_screen.dart';
import 'package:dw_echosphere_app/View/Screen/Subcategory/sub_cat_screen.dart';
import 'package:dw_echosphere_app/View/Widgets/search_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExecutiveServiceScreen extends StatefulWidget {
  const ExecutiveServiceScreen({super.key});

  @override
  State<ExecutiveServiceScreen> createState() => _ExecutiveServiceScreenState();
}

class _ExecutiveServiceScreenState extends State<ExecutiveServiceScreen> {
  final ServiceController serviceController =
      Get.isRegistered<ServiceController>()
          ? Get.find<ServiceController>()
          : Get.put(ServiceController());
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      serviceController.getServices();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceData> _filteredServices(List<ServiceData> services) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return services;

    return services.where((service) {
      final name = service.name?.toLowerCase() ?? '';
      final description = service.description?.toLowerCase() ?? '';

      return name.contains(query) || description.contains(query);
    }).toList();
  }

  Future<void> _refreshServices() => serviceController.getServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      appBar: AppBar(
        backgroundColor: premiumScaffoldColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: goldPrimaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Services',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: goldPrimaryColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Explore available services',
              style: TextStyle(
                fontSize: 11,
                color: premiumMutedTextColor.withOpacity(0.8),
                letterSpacing: 0.2,
              ),
            )
          ],
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: goldPrimaryColor,
        foregroundColor: luxuryBlackColor,
        onPressed: () async {
          final created = await Navigator.of(context).push<bool>(
            MaterialPageRoute(
              builder: (_) => const CreateServiceRequestScreen(),
            ),
          );
          if (created == true) {
            _refreshServices();
          }
        },
        label: const Text(
          "Create",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
        icon: const Icon(Icons.add_rounded),
      ),
      body: Stack(
        children: [
          const _ExecutiveBackgroundGlow(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Column(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Executive Panel",
                      style: TextStyle(
                        color: goldPrimaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Manage service requests & categories",
                      style: TextStyle(
                        color: premiumMutedTextColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                SearchFilterBar(
                  controller: _searchController,
                  hintText: AppString.searchServices,
                  onSearchChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GetBuilder<ServiceController>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        return const _ExecutiveSkeletonList();
                      }

                      final services = _filteredServices(controller.services);

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
                                      AppString.noServicesFound,
                                      style: TextStyle(
                                        color: premiumTextColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Text(
                                      "Try another keyword",
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 12),
                            child: Row(
                              children: [
                                Text(
                                  "${services.length} Services Available",
                                  style: const TextStyle(
                                    color: goldPrimaryColor,
                                    fontWeight: FontWeight.w700,
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

                                  return _ServiceCard(
                                    service: service,
                                    serviceName: serviceName,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => SubServiceScreen(
                                            serviceId: service.id,
                                            serviceName: serviceName,
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
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceData service;
  final String serviceName;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.serviceName,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
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
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: goldPrimaryColor.withOpacity(.08),
                blurRadius: 30,
                offset: const Offset(0, 6),
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
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff0F3D2E),
                                  Color(0xff145A41),
                                ],
                              ),
                              border: Border.all(
                                color: premiumGoldBorderColor,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: goldPrimaryColor.withOpacity(.15),
                                  blurRadius: 12,
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                serviceInitial,
                                style: const TextStyle(
                                  color: goldPrimaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.serviceName.toUpperCase(),
                                  style: const TextStyle(
                                    color: premiumTextColor,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 16,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                if (widget.service.description != null &&
                                    widget.service.description!.trim().isNotEmpty) ...[
                                  const SizedBox(height: 6),
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
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(
                          color: premiumBorderColor,
                          height: 1,
                        ),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "View Details",
                            style: TextStyle(
                              color: goldPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.open_in_new_rounded,
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

class _ExecutiveSkeletonList extends StatelessWidget {
  const _ExecutiveSkeletonList();

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

class _ExecutiveBackgroundGlow extends StatelessWidget {
  const _ExecutiveBackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: 42,
          right: -72,
          child: _ExecutiveGlowSpot(size: 190, opacity: 0.08),
        ),
        Positioned(
          bottom: 84,
          left: -88,
          child: _ExecutiveGlowSpot(size: 220, opacity: 0.06),
        ),
      ],
    );
  }
}

class _ExecutiveGlowSpot extends StatelessWidget {
  final double size;
  final double opacity;

  const _ExecutiveGlowSpot({
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
