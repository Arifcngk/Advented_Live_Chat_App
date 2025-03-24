import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UsersViewScreen extends StatelessWidget {
  const UsersViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kullanıcılar',
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
      body: Center(child: Text("User")),
    );
  }
}
