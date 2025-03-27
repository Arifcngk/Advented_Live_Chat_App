import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum TabItem { Users, Profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title, required this.icon});
  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users: TabItemData(
      title: "User",
      icon: Icons.person_outline_outlined,
    ),
    TabItem.Profile: TabItemData(title: "Profile", icon: Icons.settings),
  };
}
