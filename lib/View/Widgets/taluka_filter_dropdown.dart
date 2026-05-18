import 'package:echosphere/Api/ResponseModel/taluka_response_model.dart';
import 'package:echosphere/View/Constant/app_color.dart';
import 'package:echosphere/View/Controller/taluka_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TalukaFilterDropdown extends StatelessWidget {
  final int? selectedTalukaId;
  final ValueChanged<TalukaData?> onChanged;
  final Future<void> Function() onRetry;

  const TalukaFilterDropdown({
    super.key,
    required this.selectedTalukaId,
    required this.onChanged,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TalukaController>(
      builder: (controller) {
        final isLoading = controller.isLoading && controller.talukas.isEmpty;
        final hasError =
            controller.errorMessage != null && controller.talukas.isEmpty;
        final hasSelectedTaluka = selectedTalukaId != null &&
            controller.talukas.any((taluka) => taluka.id == selectedTalukaId);
        final selectedValue = hasSelectedTaluka ? selectedTalukaId! : 0;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: premiumSurfaceTintColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: premiumGoldBorderColor),
            boxShadow: const [
              BoxShadow(
                color: premiumShadowColor,
                offset: Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: goldPrimaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: hasError || isLoading ? null : selectedValue,
                    isExpanded: true,
                    dropdownColor: premiumSurfaceTintColor,
                    iconEnabledColor: goldPrimaryColor,
                    hint: Text(
                      hasError
                          ? 'Unable to load talukas'
                          : isLoading
                              ? 'Loading talukas...'
                              : 'Select taluka',
                      style: const TextStyle(
                        color: grey400Color,
                        fontSize: 16,
                      ),
                    ),
                    style: const TextStyle(
                      color: darkTextColor,
                      fontSize: 16,
                    ),
                    items: [
                      const DropdownMenuItem<int>(
                        value: 0,
                        child: Text('All talukas'),
                      ),
                      ...controller.talukas
                          .where((taluka) => taluka.id != null)
                          .map(
                        (taluka) => DropdownMenuItem<int>(
                          value: taluka.id!,
                          child: Text(taluka.name ?? 'Unnamed taluka'),
                        ),
                      ),
                    ],
                    onChanged: isLoading || hasError
                        ? null
                        : (value) {
                            if (value == null || value == 0) {
                              onChanged(null);
                              return;
                            }

                            TalukaData? taluka;
                            for (final item in controller.talukas) {
                              if (item.id == value) {
                                taluka = item;
                                break;
                              }
                            }
                            onChanged(taluka);
                          },
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: primaryGreenColor,
                  ),
                )
              else if (hasError)
                IconButton(
                  tooltip: 'Retry',
                  onPressed: onRetry,
                  icon: const Icon(
                    Icons.refresh,
                    color: goldPrimaryColor,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
