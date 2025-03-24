import 'package:flutter/material.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeViewScreen extends StatelessWidget {
  final UserModel user;
  HomeViewScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Future<bool?> signOut(BuildContext context) async {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      bool? result = await userViewModel.signOut();
      return result;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Live Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [Text('Hoşgeldiniz ${user.userID}'), SizedBox(height: 8)],
        ),
      ),
    );
  }
}
