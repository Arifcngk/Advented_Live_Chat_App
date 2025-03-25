import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_chat/model/user_model.dart';

class ChatRoomViewScreen extends StatefulWidget {
  final UserModel? currentUser;
  final UserModel chatUser;

  const ChatRoomViewScreen({
    super.key,
    required this.currentUser,
    required this.chatUser,
  });

  @override
  State<ChatRoomViewScreen> createState() => _ChatRoomViewScreenState();
}

class _ChatRoomViewScreenState extends State<ChatRoomViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Text("current user : ${widget.currentUser!.userName}"),
          Text("karşı taraf :${widget.chatUser.userName}"),
        ],
      ),
    );
  }
}
