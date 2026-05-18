import 'package:echosphere/Api/ResponseModel/taluka_response_model.dart';
import 'package:echosphere/Api/ResponseModel/service_response_model.dart';
import 'package:echosphere/View/Constant/app_string.dart';
import 'package:echosphere/View/Controller/service_controller.dart';
import 'package:echosphere/View/Controller/taluka_controller.dart';
import 'package:echosphere/View/Screen/Subcategory/sub_cat_screen.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Widgets/taluka_filter_dropdown.dart';
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
        child: Column(
          children: [
            TalukaFilterDropdown(
              selectedTalukaId: _selectedTalukaId,
              onChanged: _onTalukaChanged,
              onRetry: talukaController.getTalukas,
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

                  final services = controller.services;

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

                        return _ServiceTile(
                          service: service,
                          serviceName: serviceName,
                          talukaId: _selectedTalukaId,
                          talukaName: _selectedTalukaName,
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

class _ServiceTile extends StatelessWidget {
  final ServiceData service;
  final String serviceName;
  final int? talukaId;
  final String? talukaName;

  const _ServiceTile({
    required this.service,
    required this.serviceName,
    required this.talukaId,
    required this.talukaName,
  });

  @override
  Widget build(BuildContext context) {
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
                  talukaId: talukaId,
                  talukaName: talukaName,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundColor: primaryGreenColor.withOpacity(0.12),
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
  }
}
