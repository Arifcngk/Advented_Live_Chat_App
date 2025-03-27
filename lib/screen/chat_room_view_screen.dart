import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:live_chat/model/chat_model.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatRoomViewScreen extends StatefulWidget {
  final UserModel? currentUser;
  final UserModel? chatUser;
  final VoidCallback? onPop;

  const ChatRoomViewScreen({this.currentUser, this.chatUser, this.onPop});

  @override
  _ChatRoomViewScreenState createState() => _ChatRoomViewScreenState();
}

class _ChatRoomViewScreenState extends State<ChatRoomViewScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      print("Gönderilen mesaj: ${_messageController.text}");
      ChatModel _savedMessage = ChatModel(
        sender: widget.currentUser!.userID,
        receiver: widget.chatUser!.userID,
        message: _messageController.text,
        isMessageSender: true,
      );
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      var result = await userViewModel.saveMessage(_savedMessage);
      if (result) {
        _messageController.clear();
      } else {
        print("Mesaj kaydedilemedi!");
      }
    }
  }

  String _formatTime(DateTime? date) {
    if (date == null) return "";
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    UserModel? currentUser = widget.currentUser;
    UserModel? chatUser = widget.chatUser;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          widget.onPop?.call();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _customAppbar(context),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatModel>>(
                stream: userViewModel.getMessages(
                  currentUser!.userID,
                  chatUser!.userID,
                ),
                builder: (context, msjList) {
                  print("Stream verisi: ${msjList.data}"); // Debug
                  print(
                    "Dinlenen yol: ${currentUser.userID}---${chatUser.userID}",
                  );
                  if (msjList.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!msjList.hasData ||
                      msjList.data == null ||
                      msjList.data!.isEmpty) {
                    return Center(child: Text("Henüz mesaj yok."));
                  }
                  var allMessage = msjList.data!;
                  return ListView.builder(
                    itemCount: allMessage.length,
                    itemBuilder: (context, index) {
                      return chatTextAreaWidget(allMessage[index]);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFF6F6F6),
                        filled: true,
                        focusColor: Color(0xFFD0ECE8),
                        hintText: "Mesajınızı yazın...",
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black38,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF55A99D),
                          Color(0xFF007665),
                        ], // Renk geçişi (Mavi → Mor)
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: FloatingActionButton(
                      onPressed: _sendMessage,
                      backgroundColor:
                          Colors.transparent, // Arka planı saydam yap
                      elevation: 0, // Gölgeyi kaldır
                      child: Center(
                        child: Image.asset(
                          "assets/icons/send.png",
                          width: 26,
                          height: 26,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  PreferredSize _customAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(40), // AppBar yüksekliği
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Color(0xFFE4E4E4), blurRadius: 2)],
        ),
        padding: EdgeInsets.only(top: 26),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                widget.onPop?.call();
                Navigator.of(context).pop();
              },
            ),
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  widget.chatUser?.profileURL != null
                      ? NetworkImage(widget.chatUser!.profileURL!)
                      : null,
              child:
                  widget.chatUser?.profileURL == null
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.chatUser?.userName ?? "Sohbet Odası",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Çevrimiçi", // Kullanıcının durumunu buradan güncelleyebilirsin
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Spacer(),
            Image.asset(
              "assets/icons/phone.png",
              height: 20,
              width: 16,
              color: Colors.black,
            ),
            SizedBox(width: 30),
            Image.asset(
              "assets/icons/camera.png",
              height: 17,
              width: 24,
              color: Colors.black,
            ),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Widget chatTextAreaWidget(ChatModel allMessage) {
    Color gelenMesaj = Color(0xFFE4E4E4); // Gelen mesaj rengi
    Color gidenMesaj = Color(0xFFD0ECE8); // Giden mesaj rengi
    var benimMesajmi = allMessage.isMessageSender;

    if (benimMesajmi) {
      // Giden mesaj tasarımı (sağa hizalı, mavi)
      return Padding(
        padding: const EdgeInsets.all(8.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // Sağa hizala
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(0), // Sağ alt köşe düz
                ),
                color: gidenMesaj,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              margin: EdgeInsets.only(left: 40.0), // Sol tarafta boşluk bırak
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    allMessage.message ?? "Mesaj yok",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF007665),
                    ),
                  ),
                  Text(
                    _formatTime(allMessage.date) ?? "Mesaj yok",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      // Gelen mesaj tasarımı (sola hizalı, yeşil)
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Sola hizala
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      widget.chatUser?.profileURL != null
                          ? NetworkImage(widget.chatUser!.profileURL!)
                          : null,
                  child:
                      widget.chatUser?.profileURL == null
                          ? Icon(Icons.person, color: Colors.white)
                          : null,
                ),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(0), // Sol alt köşe düz
                      bottomRight: Radius.circular(24),
                    ),
                    color: gelenMesaj,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.only(
                    right: 40.0,
                    left: 20,
                  ), // Sağ tarafta boşluk bırak
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        allMessage.message ?? "Mesaj yok",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _formatTime(allMessage.date) ?? "Mesaj yok",
                        textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
}
