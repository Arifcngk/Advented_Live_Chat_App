import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        leading: IconButton(
          onPressed: () => signOut(context),
          icon: Icon(Icons.arrow_back_sharp),
        ),
        title: Text(
          'Chat',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),

        centerTitle: false,
        backgroundColor: Color(0xFFF8FAFC),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Image.asset("assets/icons/edit.png", width: 24, height: 24),
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
