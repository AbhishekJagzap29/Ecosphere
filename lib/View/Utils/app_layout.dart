import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// SUCCESS SNACKBAR

successSnackBar(
  String title,
  String message,
) {
  return Get.showSnackbar(
    GetSnackBar(
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      borderRadius: 18,
      backgroundColor: const Color(0xFF171717),
      borderWidth: 1.3,
      borderColor: goldPrimaryColor.withOpacity(0.35),
      barBlur: 18,
      boxShadows: [
        BoxShadow(
          color: goldPrimaryColor.withOpacity(0.12),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
        const BoxShadow(
          color: Colors.black54,
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ],
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      titleText: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: goldPrimaryColor.withOpacity(0.12),
              border: Border.all(
                color: goldPrimaryColor.withOpacity(0.25),
              ),
            ),
            child: const Icon(
              Icons.done_all_rounded,
              color: goldPrimaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          top: 6,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white.withOpacity(0.82),
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ),
    ),
  );
}

// ERROR SNACKBAR

errorSnackBar(
  String title,
  String error,
) {
  return Get.showSnackbar(
    GetSnackBar(
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 25,
      ),
      borderRadius: 18,
      backgroundColor: const Color(0xFF1A1515),
      borderWidth: 1.3,
      borderColor: const Color(0xFF8B2E2E),
      barBlur: 18,
      boxShadows: [
        BoxShadow(
          color: const Color(0xFF8B2E2E).withOpacity(0.16),
          blurRadius: 22,
          offset: const Offset(0, 10),
        ),
        const BoxShadow(
          color: Colors.black54,
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ],
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      titleText: Row(
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE57373).withOpacity(0.12),
              border: Border.all(
                color: const Color(0xFFE57373).withOpacity(0.25),
              ),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFE57373),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(
          left: 50,
          top: 6,
        ),
        child: Text(
          error,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.82),
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
            height: 1.45,
          ),
        ),
      ),
    ),
  );
}

/// =========================
/// PREMIUM LOADER
/// =========================
showCircular() {
  return const Center(
    child: SizedBox(
      height: 34,
      width: 34,
      child: CircularProgressIndicator(
        color: goldPrimaryColor,
        strokeWidth: 2.8,
      ),
    ),
  );
}
