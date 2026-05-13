import 'package:echosphere/Api/ResponseModel/service_response_model.dart';
import 'package:echosphere/View/Constant/app_string.dart';
import 'package:echosphere/View/Constant/shared_prefs.dart';
import 'package:echosphere/View/Controller/service_controller.dart';
// import 'package:echosphere/View/Screen/BottomBarScreen/sub_service_screen.dart';
import 'package:echosphere/View/Screen/ServiceRequest/create_service_request_screen.dart';
import 'package:echosphere/View/Screen/Subcategory/sub_cat_screen.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Widgets/search_filter.dart';
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
    final isExecutive =
        preferences.getString(SharedPreference.userType) == 'executive';

    return Scaffold(
      floatingActionButton: isExecutive
          ? FloatingActionButton(
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
              child: const Icon(Icons.add_rounded),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          children: [
            SearchFilterBar(
              controller: _searchController,
              hintText: AppString.searchServices,
              onSearchChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GetBuilder<ServiceController>(
                builder: (controller) {
                  if (controller.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryGreenColor,
                      ),
                    );
                  }

                  final services = _filteredServices(controller.services);

                  if (services.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refreshServices,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 160),
                          Center(
                            child: Text(AppString.noServicesFound),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshServices,
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: services.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        final serviceName = service.name ?? 'Unnamed service';
                        final serviceInitial = serviceName.trim().isNotEmpty
                            ? serviceName.trim()[0].toUpperCase()
                            : '?';

                        return Material(
                          color: premiumSurfaceColor,
                          borderRadius: BorderRadius.circular(18),
                          elevation: 0,
                          shadowColor: transparentColor,
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
                              leading: CircleAvatar(
                                backgroundColor:
                                    primaryGreenColor.withOpacity(0.12),
                                child: Text(
                                  serviceInitial,
                                  style: const TextStyle(
                                    color: primaryGreenColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              title: Text(
                                serviceName,
                                style: const TextStyle(
                                  color: premiumTextColor,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              subtitle: service.description == null ||
                                      service.description!.trim().isEmpty
                                  ? null
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        service.description!,
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
