import 'package:echosphere/View/Constant/app_color.dart';
import 'package:flutter/material.dart';

class CustomBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: premiumSurfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: premiumGoldBorderColor),
          boxShadow: const [
            BoxShadow(
              color: premiumShadowColor,
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: premiumGoldShadowColor,
              blurRadius: 18,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            selectedItemColor: goldPrimaryColor,
            unselectedItemColor: premiumMutedTextColor,
            backgroundColor: premiumSurfaceColor,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            onTap: onItemTapped,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business_center_outlined),
                activeIcon: Icon(Icons.business_center_rounded),
                label: 'Services',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions),
                activeIcon: Icon(Icons.subscriptions),
                label: 'Plans',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                activeIcon: Icon(Icons.info_rounded),
                label: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
