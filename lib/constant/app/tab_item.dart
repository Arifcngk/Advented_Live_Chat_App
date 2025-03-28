import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum  TabItem { Users, Chats, Profile }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData({required this.title, required this.icon});
  static Map<TabItem, TabItemData> allTabs = {
    TabItem.Users: TabItemData(
      title: "Kişiler",
      icon: Icons.person_outline_outlined,
    ),
    TabItem.Chats: TabItemData(title: "Sohbet", icon: Icons.chat),
    TabItem.Profile: TabItemData(title: "Ayarlar", icon: Icons.settings),
  };
}
