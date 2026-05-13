import 'package:echosphere/Api/ResponseModel/sub_service_response_model.dart';
import 'package:echosphere/View/Constant/app_string.dart';
import 'package:echosphere/View/Controller/sub_service_controller.dart';
import 'package:echosphere/View/Screen/Subcategory/SubCategoryDetails/sub_cat_det_screen.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubServiceScreen extends StatefulWidget {
  final int? serviceId;
  final String? serviceName;

  const SubServiceScreen({
    super.key,
    this.serviceId,
    this.serviceName,
  });

  @override
  State<SubServiceScreen> createState() => _SubServiceScreenState();
}

class _SubServiceScreenState extends State<SubServiceScreen> {
  late final SubServiceController subServiceController;
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchInput = ''.obs;
  final RxString _searchQuery = ''.obs;
  late final Worker _searchDebounce;
  List<SubServiceData>? _lastSource;
  String _lastQuery = '';
  List<SubServiceData> _cachedSubServices = [];
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
    _searchDebounce = debounce<String>(
      _searchInput,
      (value) => _searchQuery.value = value,
      time: const Duration(milliseconds: 300),
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   subServiceController.getSubServices(
    //     serviceId: widget.serviceId,
    //   );
    // });
    subServiceController.getSubServices(
      serviceId: widget.serviceId,
    );
  }

  @override
  void dispose() {
    _searchDebounce.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<SubServiceData> _filteredSubServices(
    List<SubServiceData> subServices,
    String searchQuery,
  ) {
    final query = searchQuery.trim().toLowerCase();
    if (identical(_lastSource, subServices) && _lastQuery == query) {
      return _cachedSubServices;
    }

    _lastSource = subServices;
    _lastQuery = query;

    if (query.isEmpty) {
      _cachedSubServices = subServices;
      return _cachedSubServices;
    }

    _cachedSubServices = subServices.where((subService) {
      final name = subService.name?.toLowerCase() ?? '';
      final description = subService.description?.toLowerCase() ?? '';

      return name.contains(query) || description.contains(query);
    }).toList();

    return _cachedSubServices;
  }

  Future<void> _refreshSubServices() => subServiceController.getSubServices(
        serviceId: widget.serviceId,
      );

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
      appBar: AppBar(
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          children: [
            SearchFilterBar(
              controller: _searchController,
              hintText: AppString.searchSubServices,
              onSearchChanged: (value) => _searchInput.value = value,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () {
                  final currentSearchQuery = _searchQuery.value;

                  return GetBuilder<SubServiceController>(
                    builder: (controller) {
                      final sourceSubServices = _subServicesForRender(
                        controller,
                      );

                      if (controller.isLoading && sourceSubServices.isEmpty) {
                        return const _SubServiceSkeletonList();
                      }

                      final subServices = _filteredSubServices(
                        sourceSubServices,
                        currentSearchQuery,
                      );

                      if (subServices.isEmpty) {
                        return _SubServiceEmptyState(
                          searchQuery: currentSearchQuery.trim(),
                          onRefresh: _refreshSubServices,
                          onRetry: _refreshSubServices,
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: _refreshSubServices,
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: subServices.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final subService = subServices[index];
                            final subServiceName =
                                subService.name ?? 'Unnamed sub service';

                            return _SubServiceTile(
                              subService: subService,
                              subServiceName: subServiceName,
                            );
                          },
                        ),
                      );
                    },
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

class _SubServiceTile extends StatelessWidget {
  final SubServiceData subService;
  final String subServiceName;

  const _SubServiceTile({
    required this.subService,
    required this.subServiceName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _avatarColors(subServiceName);

    return Material(
      color: transparentColor,
      child: Container(
        decoration: BoxDecoration(
          color: premiumSurfaceColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: premiumGoldBorderColor),
          boxShadow: const [
            BoxShadow(
              color: premiumShadowColor,
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          onTap: () {
            Get.to(
              () => ServiceDetailScreen(
                subserviceId: subService.id,
                subserviceName: subServiceName,
              ),
            );
          },
          leading: Hero(
            tag: 'sub-service-${subService.id ?? subService.hashCode}',
            child: CircleAvatar(
              radius: 23,
              backgroundColor: colors.background,
              child: Text(
                _initialFor(subServiceName),
                style: TextStyle(
                  color: colors.foreground,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          title: Text(
            subServiceName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: premiumTextColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: subService.description == null ||
                  subService.description!.trim().isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    subService.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: premiumMutedTextColor,
                      height: 1.3,
                    ),
                  ),
                ),
          trailing: const Icon(
            Icons.chevron_right,
            color: premiumMutedTextColor,
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
