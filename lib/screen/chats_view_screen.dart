import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_chat/model/message_model.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatsViewScreen extends StatefulWidget {
  const ChatsViewScreen({super.key});

  @override
  State<ChatsViewScreen> createState() => _ChatsViewScreenState();
}

class _ChatsViewScreenState extends State<ChatsViewScreen> {
  void getAllMsj() async {
    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      var chats =
          await FirebaseFirestore.instance
              .collection("chats")
              .where("owner", isEqualTo: userViewModel.user!.userID)
              .orderBy("timestamp", descending: true)
              .get();

      for (var chat in chats.docs) {
        print("Conversation: ${chat.data()}");
      }

      if (chats.docs.isEmpty) {
        print("No conversations found for user: ${userViewModel.user!.userID}");
      }
    } catch (e) {
      print("Error while fetching conversations: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getAllMsj(); // <--- burada çağırdık
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

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
      body: FutureBuilder<List<MessageModel>>(
        future: userViewModel.getAllConversations(userViewModel.user!.userID),
        builder: (context, chatList) {
          if (chatList.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (chatList.hasError) {
            return Center(child: Text("Bir hata oluştu: ${chatList.error}"));
          } else if (!chatList.hasData || chatList.data!.isEmpty) {
            return Center(child: Text("Hiç sohbet bulunamadı."));
          } else {
            var getAllChats = chatList.data!;

            return ListView.builder(
              itemCount: getAllChats.length,
              itemBuilder: (context, index) {
                var _chat = getAllChats[index];
                print("mesaj sahibi:" + _chat.owner);
                print("mesahı alan " + _chat.chatWith);
                print("mesaj içeriği " + _chat.lastMessage);
                return ListTile(
                  title: Text(_chat.chatWithID),
                  subtitle: Text(_chat.lastMessage),
                );
              },
            );
          }
        },
      ),
    );
  }
}
