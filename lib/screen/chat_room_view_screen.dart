import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

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
  var messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

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
        leading: IconButton(
          onPressed: () {
            return Navigator.of(context).pop(); // Geri git
          },
          icon: Icon(Icons.abc),
        ),

        centerTitle: false,
        backgroundColor: Color(0xFFF8FAFC),
      ),
      body: Column(
        children: [
          Expanded(child: Text("Konusma")),
          Container(
            padding: EdgeInsets.only(bottom: 8, left: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    cursorColor: Colors.amber,
                    style: TextStyle(fontSize: 23),
                    decoration: InputDecoration(
                      fillColor: Colors.green,
                      filled: true,
                      hintText: "mesaj ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  child: FloatingActionButton(
                    onPressed: () {},
                    elevation: 0,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.navigate_next_outlined),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> signOut(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    bool? result = await userViewModel.signOut();
    return result;
  }
}
