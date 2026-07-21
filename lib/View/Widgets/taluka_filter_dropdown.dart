import 'package:dw_echosphere_app/Api/ResponseModel/taluka_response_model.dart';
import 'package:dw_echosphere_app/View/Constant/app_color.dart';
import 'package:dw_echosphere_app/View/Controller/taluka_controller.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
        final talukaIds = [
          0,
          ...controller.talukas
              .where((taluka) => taluka.id != null)
              .map((taluka) => taluka.id!),
        ];

        String talukaNameFromId(int id) {
          if (id == 0) return 'All talukas';

          for (final taluka in controller.talukas) {
            if (taluka.id == id) {
              return taluka.name ?? 'Unnamed taluka';
            }
          }

          return 'Unnamed taluka';
        }

        return Container(
          height: 56,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: premiumSurfaceColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: premiumGoldBorderColor.withOpacity(0.35),
            ),
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
                child: DropdownSearch<int>(
                  enabled: !isLoading && !hasError,
                  selectedItem: hasError || isLoading ? null : selectedValue,
                  items: talukaIds,
                  itemAsString: talukaNameFromId,
                  compareFn: (item, selectedItem) => item == selectedItem,
                  dropdownButtonProps: const DropdownButtonProps(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: goldPrimaryColor,
                    ),
                  ),
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      hintText: hasError
                          ? 'Unable to load talukas'
                          : isLoading
                              ? 'Loading talukas...'
                              : 'Select taluka',
                      hintStyle: const TextStyle(
                        color: grey400Color,
                        fontSize: 16,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    baseStyle: const TextStyle(
                      color: darkTextColor,
                      fontSize: 16,
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: true,
                    searchDelay: Duration.zero,
                    menuProps: const MenuProps(
                      backgroundColor: premiumSurfaceTintColor,
                    ),
                    searchFieldProps: const TextFieldProps(
                      decoration: InputDecoration(
                        hintText: 'Search taluka',
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryGreenColor,
                        ),
                        filled: true,
                        fillColor: textFieldColor,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        dense: true,
                        selected: isSelected,
                        selectedTileColor: textFieldColor,
                        title: Text(
                          talukaNameFromId(item),
                          style: const TextStyle(color: darkTextColor),
                        ),
                      );
                    },
                  ),
                  onChanged: (value) {
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
