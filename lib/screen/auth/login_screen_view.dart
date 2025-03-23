import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:sign_in_button/sign_in_button.dart';

// ignore: must_be_immutable
class LoginScreenView extends StatelessWidget {
  final Function(UserModel?) onSignIn;
  AuthBase authService = locator<FirebaseAuthService>();

  LoginScreenView({super.key, required this.onSignIn});
  // Add this method to the _LoginScreenViewState class
  _anonymousLogin() async {
    UserModel? _user = await authService.signInAnonymously();
    onSignIn(_user);
    print("oturum acan user id: ${_user?.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                Buttons.google,
                onPressed: () {},
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                text: "Google ile Giriş Yap",
              ),
              SizedBox(height: 20),
              SignInButton(
                Buttons.email,
                onPressed: () {},
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                text: "Mail ile Giriş Yap",
              ),
              SizedBox(height: 20),
              SignInButton(
                Buttons.anonymous,
                onPressed: _anonymousLogin,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 20),
                text: "Anonim Olarak Giriş Yap",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
