import 'package:dw_echosphere_app/Api/ResponseModel/sub_service_response_model.dart';
import 'package:dw_echosphere_app/Api/ResponseModel/taluka_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/app_string.dart';
import 'package:dw_echosphere_app/View/Controller/sub_service_controller.dart';
import 'package:dw_echosphere_app/View/Controller/taluka_controller.dart';
import 'package:dw_echosphere_app/View/Screen/Subcategory/SubCategoryDetails/sub_cat_det_screen.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Widgets/taluka_filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubServiceScreen extends StatefulWidget {
  final int? serviceId;
  final String? serviceName;
  final int? talukaId;
  final String? talukaName;

  const SubServiceScreen({
    super.key,
    this.serviceId,
    this.serviceName,
    this.talukaId,
    this.talukaName,
  });

  @override
  State<SubServiceScreen> createState() => _SubServiceScreenState();
}

class _SubServiceScreenState extends State<SubServiceScreen> {
  late final SubServiceController subServiceController;
  late final TalukaController talukaController;
  int? _selectedTalukaId;
  String? _selectedTalukaName;
  List<SubServiceData> _lastLoadedSubServices = [];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<SubServiceController>()) {
      Get.lazyPut<SubServiceController>(
        () => SubServiceController(),
        fenix: true,
      );
    }
    subServiceController = Get.find<SubServiceController>();
    talukaController = Get.isRegistered<TalukaController>()
        ? Get.find<TalukaController>()
        : Get.put(TalukaController());
    _selectedTalukaId = widget.talukaId;
    _selectedTalukaName = widget.talukaName;

    if (talukaController.talukas.isEmpty) {
      talukaController.getTalukas();
    }
    subServiceController.getSubServices(
      serviceId: widget.serviceId,
      talukaId: _selectedTalukaId,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshSubServices() => subServiceController.getSubServices(
        serviceId: widget.serviceId,
        talukaId: _selectedTalukaId,
      );

  void _onTalukaChanged(TalukaData? taluka) {
    setState(() {
      _selectedTalukaId = taluka?.id;
      _selectedTalukaName = taluka?.name;
    });
    subServiceController.getSubServices(
      serviceId: widget.serviceId,
      talukaId: taluka?.id,
    );
  }

  List<SubServiceData> _subServicesForRender(SubServiceController controller) {
    if (controller.subServices.isNotEmpty) {
      _lastLoadedSubServices = controller.subServices;
      return controller.subServices;
    }

    if (controller.isLoading && _lastLoadedSubServices.isNotEmpty) {
      return _lastLoadedSubServices;
    }

    return controller.subServices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumScaffoldColor,
      appBar: AppBar(
        toolbarHeight: 52,
        title: Text(widget.serviceName ?? AppString.subServices),
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
          const _SubServiceBackgroundGlow(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.serviceName ?? "Sub Categories",
                        style: const TextStyle(
                          color: goldPrimaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Choose a Sub Category",
                        style: TextStyle(
                          color: premiumMutedTextColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  TalukaFilterDropdown(
                    selectedTalukaId: _selectedTalukaId,
                    onChanged: _onTalukaChanged,
                    onRetry: talukaController.getTalukas,
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: GetBuilder<SubServiceController>(
                      builder: (controller) {
                        final subServices = _subServicesForRender(
                          controller,
                        );

                        if (controller.isLoading && subServices.isEmpty) {
                          return const _SubServiceSkeletonList();
                        }

                        if (subServices.isEmpty) {
                          return _SubServiceEmptyState(
                            searchQuery: '',
                            onRefresh: _refreshSubServices,
                            onRetry: _refreshSubServices,
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
                                    "${subServices.length} Sub Categories",
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
                                onRefresh: _refreshSubServices,
                                child: ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  itemCount: subServices.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final subService = subServices[index];
                                    final subServiceName =
                                        subService.name ?? 'Unnamed sub service';

                                    return _SubServiceCard(
                                      subService: subService,
                                      subServiceName: subServiceName,
                                      talukaId: _selectedTalukaId,
                                      talukaName: _selectedTalukaName,
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

class _SubServiceCard extends StatefulWidget {
  final SubServiceData subService;
  final String subServiceName;
  final int? talukaId;
  final String? talukaName;

  const _SubServiceCard({
    required this.subService,
    required this.subServiceName,
    required this.talukaId,
    required this.talukaName,
  });

  @override
  State<_SubServiceCard> createState() => _SubServiceCardState();
}

class _SubServiceCardState extends State<_SubServiceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final serviceInitial = _initialFor(widget.subServiceName);
    final colors = _avatarColors(widget.subServiceName);

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: () {
          Get.to(
            () => ServiceDetailScreen(
              subserviceId: widget.subService.id,
              subserviceName: widget.subServiceName,
              talukaId: widget.talukaId,
              talukaName: widget.talukaName,
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: premiumSurfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: premiumGoldBorderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.30),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: goldPrimaryColor.withOpacity(.06),
                blurRadius: 25,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    height: 5,
                    width: 50,
                    decoration: const BoxDecoration(
                      color: goldPrimaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 15, 14, 13),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              colors.background,
                              colors.background.withOpacity(0.8),
                            ],
                          ),
                          border: Border.all(
                            color: premiumGoldBorderColor.withOpacity(0.5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            serviceInitial,
                            style: TextStyle(
                              color: colors.foreground,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.subServiceName,
                              style: const TextStyle(
                                color: premiumTextColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 14.5,
                              ),
                            ),
                            if (widget.subService.description != null &&
                                widget.subService.description!.trim().isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                widget.subService.description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: premiumMutedTextColor,
                                  fontSize: 12.5,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View",
                            style: TextStyle(
                              color: goldPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: goldPrimaryColor,
                            size: 13,
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

  static String _initialFor(String value) {
    final trimmed = value.trim();
    return trimmed.isNotEmpty ? trimmed[0].toUpperCase() : '?';
  }

  static _AvatarColors _avatarColors(String value) {
    const palette = [
      _AvatarColors(greenTintColor, primaryGreenColor),
      _AvatarColors(blueTintColor, blueAvatarColor),
      _AvatarColors(orangeTintColor, orangeAvatarColor),
      _AvatarColors(purpleTintColor, purpleAvatarColor),
      _AvatarColors(tealTintColor, tealAvatarColor),
    ];

    return palette[value.hashCode.abs() % palette.length];
  }
}

class _SubServiceBackgroundGlow extends StatelessWidget {
  const _SubServiceBackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned(
          top: 42,
          right: -72,
          child: _SubServiceGlowSpot(size: 190, opacity: 0.08),
        ),
        Positioned(
          bottom: 84,
          left: -88,
          child: _SubServiceGlowSpot(size: 220, opacity: 0.06),
        ),
      ],
    );
  }
}

class _SubServiceGlowSpot extends StatelessWidget {
  final double size;
  final double opacity;

  const _SubServiceGlowSpot({
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

class _AvatarColors {
  final Color background;
  final Color foreground;

  const _AvatarColors(this.background, this.foreground);
}

class _SubServiceEmptyState extends StatelessWidget {
  final String searchQuery;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onRetry;

  const _SubServiceEmptyState({
    required this.searchQuery,
    required this.onRefresh,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final hasSearch = searchQuery.isNotEmpty;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 140),
          Icon(
            hasSearch ? Icons.search_off : Icons.error_outline,
            color: primaryGreenColor,
            size: 42,
          ),
          const SizedBox(height: 14),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                hasSearch
                    ? 'No results found for "$searchQuery"'
                    : AppString.somethingWentWrong,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (!hasSearch) ...[
            const SizedBox(height: 8),
            const Center(
              child: Text(AppString.noSubServicesFound),
            ),
            const SizedBox(height: 18),
            Center(
              child: OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubServiceSkeletonList extends StatelessWidget {
  const _SubServiceSkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _SubServiceSkeletonTile(),
    );
  }
}

class _SubServiceSkeletonTile extends StatelessWidget {
  const _SubServiceSkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: premiumSurfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: premiumGoldBorderColor),
        boxShadow: const [
          BoxShadow(
          color: premiumShadowColor,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: const Row(
        children: [
          _SkeletonBox(width: 46, height: 46, radius: 23),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: double.infinity, height: 14),
                SizedBox(height: 10),
                _SkeletonBox(width: 180, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..repeat(period: const Duration(milliseconds: 1200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final slide = _controller.value * 2;

            return LinearGradient(
              begin: Alignment(-1 + slide, 0),
              end: Alignment(1 + slide, 0),
              colors: const [
                skeletonBaseColor,
                skeletonHighlightColor,
                skeletonBaseColor,
              ],
              stops: const [0.1, 0.5, 0.9],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: premiumSurfaceTintColor,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
