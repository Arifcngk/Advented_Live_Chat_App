import 'package:flutter/material.dart';
import 'package:live_chat/screen/auth/login_screen_view.dart';
import 'package:live_chat/screen/home_view_screen.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class LandingViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    if (userViewModel.state == ViewState.Idle) {
      if (userViewModel.user == null) {
        return LoginScreenView();
      } else {
        return HomeViewScreen(user: userViewModel.user!);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(backgroundColor: Colors.red),
        ),
      );
    }
  }
}
