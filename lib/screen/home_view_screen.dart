import 'package:flutter/material.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/constant/app/tab_item.dart';
import 'package:live_chat/screen/profile_view_screen.dart';
import 'package:live_chat/screen/users_view_screen.dart';
import 'package:live_chat/screen/widgets/custom_bottom_navigator_widget.dart';

// ignore: must_be_immutable
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
        if (didPop) return; // Eğer zaten pop edildiyse işlem yapma

        final navigator = navigatorStateKey[_currentTab]?.currentState;
        if (navigator != null && await navigator.maybePop()) {
          // Eğer aktif navigator geri gidebiliyorsa, gitmesine izin ver
          return;
        }

        print("Ana ekranda geri gitme engellendi!");
      },
      child: CustomBottomNavigatorWidget(
        navigatorKeys: navigatorStateKey,
        createdScreen: allScreen(),
        currentTab: _currentTab,
        onSelectedItem: (selectedTab) {
          setState(() {
            _currentTab = selectedTab;
          });
          print(selectedTab);
        },
      ),
    );
  }
}
