import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsViewScreen extends StatefulWidget {
  const ChatsViewScreen({super.key});

  @override
  State<ChatsViewScreen> createState() => _ChatsViewScreenState();
}

class _ChatsViewScreenState extends State<ChatsViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sohbet',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 26,
          ),
        ),
        centerTitle: false,
        backgroundColor: Color(0xFFF8FAFC),
      ),
    );
  }
}
