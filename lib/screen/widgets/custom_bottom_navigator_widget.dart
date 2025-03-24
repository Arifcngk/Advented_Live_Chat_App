import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/tab_item.dart';

class CustomBottomNavigatorWidget extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedItem;
  final Map<TabItem, Widget> createdScreen;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  CustomBottomNavigatorWidget({
    super.key,
    required this.currentTab,
    required this.onSelectedItem,
    required this.createdScreen,
    required this.navigatorKeys,
  });

  BottomNavigationBarItem _createdNavItem(TabItem tabItem) {
    final currentTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(currentTab!.icon, color: Colors.black),
      label: currentTab.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _createdNavItem(TabItem.Users),
          _createdNavItem(TabItem.Profile),
        ],
        onTap: (index) {
          final selectedTab = TabItem.values[index];
          onSelectedItem(selectedTab);
        },
      ),
      tabBuilder: (context, index) {
        final selectedTab = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[selectedTab],
          builder: (context) {
            return createdScreen[selectedTab] ?? Container();
          },
        );
      },
    );
  }
}
