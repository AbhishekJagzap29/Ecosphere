import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final String hintText;
  final Function(String) onSearchChanged;
  final bool showFilterButton;
  final VoidCallback? onFilterPressed;
  final TextEditingController? controller;

  const SearchFilterBar({
    super.key,
    this.hintText = 'Search...',
    required this.onSearchChanged,
    this.showFilterButton = false,
    this.onFilterPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            Icons.search,
            color: goldPrimaryColor,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  color: grey400Color,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: darkTextColor,
              ),
            ),
          ),
          if (showFilterButton) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: onFilterPressed,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: deepGreenTintColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune,
                  color: goldPrimaryColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
