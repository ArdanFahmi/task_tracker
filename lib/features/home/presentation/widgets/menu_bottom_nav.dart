import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:task_tracker/core/constants/app_colors.dart';

Widget buildListMenuBottomNavigation(BuildContext ctx, int selectedIndex, void Function(int) onItemTapped) {
  final menuItems = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      activeIcon: Padding(
        padding: EdgeInsets.all(6.0),
        child: Icon(SolarIconsBold.checkCircle, color: AppColors.primaryColor),
      ),
      icon: Padding(padding: EdgeInsets.all(6.0), child: Icon(SolarIconsOutline.checkCircle)),
      label: 'Tasks',
    ),
    const BottomNavigationBarItem(
      activeIcon: Padding(
        padding: EdgeInsets.all(6.0),
        child: Icon(SolarIconsBold.addCircle, color: AppColors.primaryColor),
      ),
      icon: Padding(padding: EdgeInsets.all(6.0), child: Icon(SolarIconsOutline.addCircle)),
      label: 'Add',
    ),
    const BottomNavigationBarItem(
      activeIcon: Padding(
        padding: EdgeInsets.all(6.0),
        child: Icon(SolarIconsBold.user, color: AppColors.primaryColor),
      ),
      icon: Padding(padding: EdgeInsets.all(6.0), child: Icon(SolarIconsOutline.user)),
      label: 'Profile',
    ),
  ];

  return BottomNavigationBar(
    items: menuItems,
    type: BottomNavigationBarType.fixed,
    currentIndex: selectedIndex,
    backgroundColor: AppColors.surfaceColor,
    showUnselectedLabels: true,
    selectedItemColor: AppColors.primaryColor,
    onTap: onItemTapped,
    unselectedLabelStyle: const TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w400),
    selectedLabelStyle: const TextStyle(color: AppColors.neutralColor, fontWeight: FontWeight.w500),
  );
}
