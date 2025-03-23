import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/screen/auth/login_screen_view.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/firebase_auth_service.dart';

// ignore: must_be_immutable
class HomeViewScreen extends StatelessWidget {
  final VoidCallback onSignOut;
  AuthBase authBase = locator<FirebaseAuthService>();
  HomeViewScreen({super.key, required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await authBase.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => LoginScreenView(
                          onSignIn: (user) {
                            if (user != null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          HomeViewScreen(onSignOut: onSignOut),
                                ),
                              );
                            }
                          },
                        ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(children: [Text('Hoşgeldiniz'), SizedBox(height: 8)]),
      ),
    );
  }
}
