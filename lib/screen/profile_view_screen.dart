import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ProfileViewScreen extends StatelessWidget {
  const ProfileViewScreen({super.key});

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
          'Profie',
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
      body: Center(child: Text("Profile")),
    );
  }
}
