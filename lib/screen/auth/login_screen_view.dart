import 'package:flutter/material.dart';

class LoginScreenView extends StatefulWidget {
  const LoginScreenView({super.key});

  @override
  State<LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<LoginScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
        elevation: 0,
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: Column(children: [Text("Login Screen")]),
    );
  }
}
