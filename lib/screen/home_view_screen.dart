import 'package:flutter/material.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/constant/app/tab_item.dart';
import 'package:live_chat/screen/profile_view_screen.dart';
import 'package:live_chat/screen/users_view_screen.dart';
import 'package:live_chat/screen/widgets/custom_bottom_navigator_widget.dart';

class HomeViewScreen extends StatefulWidget {
  final UserModel user;
  HomeViewScreen({super.key, required this.user});

  @override
  State<HomeViewScreen> createState() => _HomeViewScreenState();
}

class _HomeViewScreenState extends State<HomeViewScreen> {
  TabItem _currentTab = TabItem.Users;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorStateKey = {
    TabItem.Users: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> allScreen() {
    return {
      TabItem.Users: UsersViewScreen(),
      TabItem.Profile: ProfileViewScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;

        final navigator = navigatorStateKey[_currentTab]?.currentState;
        if (navigator != null && await navigator.maybePop()) {
          return;
        }

        // Root navigator’dan geri dönme durumunda
        print("Ana ekranda geri gitme engellendi!");
      },
      child: CustomBottomNavigatorWidget(
        navigatorKeys: navigatorStateKey,
        createdScreen: allScreen(),
        currentTab: _currentTab,
        onSelectedItem: (selectedTab) {
          if (selectedTab == _currentTab) {
            // Aynı tab’a tıklanırsa en başa dön
            navigatorStateKey[selectedTab]!.currentState!.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = selectedTab;
            });
          }
          print(selectedTab);
        },
      ),
    );
  }
}