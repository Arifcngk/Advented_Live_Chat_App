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

  const ChatRoomViewScreen({
    super.key,
    this.currentUser,
    this.chatUser,
    this.onPop,
  });

  @override
  _ChatRoomViewScreenState createState() => _ChatRoomViewScreenState();
}

class _ChatRoomViewScreenState extends State<ChatRoomViewScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ekran açıldığında en alta kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isNotEmpty) {
      print("Gönderilen mesaj: ${_messageController.text}");
      ChatModel savedMessage = ChatModel(
        sender: widget.currentUser!.userID,
        receiver: widget.chatUser!.userID,
        message: _messageController.text,
        isMessageSender: true,
        date: DateTime.now(), // Tarih ekledim
      );
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      var result = await userViewModel.saveMessage(savedMessage);
      if (result) {
        _messageController.clear();
        _scrollToBottom(); // Yeni mesaj gönderildiğinde en alta kaydır
      } else {
        print("Mesaj kaydedilemedi!");
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0, // reverse: true olduğu için en alta gitmek 0.0
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
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
      child: SafeArea(
        child: Scaffold(
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
                    print("Stream verisi: ${msjList.data}");
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
                    // Mesajları tarihe göre sırala (en yeni en altta)
                    allMessage.sort((a, b) {
                      final aDate = a.date ?? DateTime(1970);
                      final bDate = b.date ?? DateTime(1970);
                      return bDate.compareTo(aDate); // En yeni altta
                    });
                    // Yeni veri geldiğinde en alta kaydır
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollToBottom();
                    });
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
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
                          colors: [Color(0xFF55A99D), Color(0xFF007665)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: FloatingActionButton(
                        onPressed: _sendMessage,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
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
      ),
    );
  }

  PreferredSize _customAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF8FAFC),
          boxShadow: [BoxShadow(color: Color(0xFFE4E4E4), blurRadius: 1)],
        ),
        padding: EdgeInsets.only(top: 6),
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
                  "Çevrimiçi",
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
    _scrollController.dispose(); // ScrollController’ı temizle
    super.dispose();
  }

  Widget chatTextAreaWidget(ChatModel allMessage) {
    Color gelenMesaj = Color(0xFFE4E4E4);
    Color gidenMesaj = Color(0xFFD0ECE8);
    var benimMesajmi = allMessage.isMessageSender;

    if (benimMesajmi) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(0),
                ),
                color: gidenMesaj,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              margin: EdgeInsets.only(left: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    allMessage.message,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Color(0xFF007665),
                    ),
                  ),
                  Text(
                    _formatTime(allMessage.date),
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
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(24),
                    ),
                    color: gelenMesaj,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  margin: EdgeInsets.only(right: 40.0, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        allMessage.message,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _formatTime(allMessage.date),
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
