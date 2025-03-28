import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/tab_item.dart';
import 'package:live_chat/screen/widgets/bottom_bar_control.dart';

class CustomBottomNavigatorWidget extends StatefulWidget {
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

  @override
  _CustomBottomNavigatorWidgetState createState() =>
      _CustomBottomNavigatorWidgetState();
}

class _CustomBottomNavigatorWidgetState
    extends State<CustomBottomNavigatorWidget> {
  bool _showBottomBar = true;

  void _toggleBottomBar(bool show) {
    setState(() {
      _showBottomBar = show;
    });
  }

  BottomNavigationBarItem _createdNavItem(TabItem tabItem) {
    final currentTab = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(currentTab!.icon),
      label: currentTab.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showBottomBar) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          activeColor: Color(0xFF007665),
          iconSize: 30,
          height: 50,

          border: Border.all(color: Colors.grey),
          backgroundColor: Color(0xFFF8FAFC),

          items: [
            _createdNavItem(TabItem.Users),
            _createdNavItem(TabItem.Chats),
            _createdNavItem(TabItem.Profile),
          ],
          onTap: (index) {
            final selectedTab = TabItem.values[index];
            widget.onSelectedItem(selectedTab);
            _toggleBottomBar(true); // Tab değiştiğinde bottom bar’ı göster
          },
        ),
        tabBuilder: (context, index) {
          final selectedTab = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: widget.navigatorKeys[selectedTab],
            builder: (context) {
              return InheritedBottomBarControl(
                toggleBottomBar: _toggleBottomBar,
                child: widget.createdScreen[selectedTab] ?? Container(),
              );
            },
          );
        },
      );
    } else {
      final selectedTab = widget.currentTab;
      return CupertinoTabView(
        navigatorKey: widget.navigatorKeys[selectedTab],
        builder: (context) {
          return InheritedBottomBarControl(
            toggleBottomBar: _toggleBottomBar,
            child: widget.createdScreen[selectedTab] ?? Container(),
          );
        },
      );
    }
  }
}
