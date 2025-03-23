import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/screen/auth/login_screen_view.dart';
import 'package:live_chat/screen/home_view_screen.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/firebase_auth_service.dart';

class LandingViewScreen extends StatefulWidget {
  @override
  State<LandingViewScreen> createState() => _LandingViewScreenState();
}

class _LandingViewScreenState extends State<LandingViewScreen> {
  AuthBase authService = locator<FirebaseAuthService>();
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    try {
      UserModel? user = await authService.currentUser();
      if (mounted) {
        if (user == null) {
          Navigator.pushReplacement(
            // pushReplacement olduğundan emin ol
            context,
            MaterialPageRoute(
              builder:
                  (context) => LoginScreenView(
                    onSignIn: (user) {
                      if (user != null) {
                        _navigateToHome(user);
                      }
                    },
                  ),
            ),
          );
        } else {
          _navigateToHome(user);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bir hata oluştu: $e')));
      }
    }
  }

  void _navigateToHome(UserModel? user) {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => HomeViewScreen(
                onSignOut: () => _checkUser(), // Çıkış sonrası tekrar kontrol
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // Yükleniyor göstergesi
    );
  }
}
