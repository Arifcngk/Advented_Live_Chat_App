import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
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

  // Add this method to the _LoginScreenViewState class
  _anonymousLogin() async {
    UserCredential result = await FirebaseAuth.instance.signInAnonymously();
    print("oturum acan user id: ${result.user?.uid.toString()}");
  }
}
