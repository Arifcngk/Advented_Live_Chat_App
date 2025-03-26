import 'package:flutter/material.dart';
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
  final List<String> _messages = []; // Örnek mesaj listesi

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _messages.add(_messageController.text); // Mesajı listeye ekle
        _messageController.clear(); // Text alanını temizle
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    UserModel? currentUser = widget.currentUser;
    UserModel? chatUser = widget.chatUser;
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          widget.onPop?.call(); // Geri dönmeden önce tab bar’ı göster
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.chatUser?.userName ?? "Sohbet Odası"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.onPop?.call(); // Geri dönmeden önce tab bar’ı göster
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            // Mesaj Listesi
            Expanded(
              child: StreamBuilder<List<ChatModel>>(
                stream: userViewModel.getMessages(
                  currentUser!.userID,
                  chatUser!.userID,
                ),
                builder: (context, msjList) {
                  if (!msjList.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var allMessage = msjList.data;
                  return ListView.builder(
                    itemCount: allMessage!.length,
                    itemBuilder: (context, index) {
                      return Text(allMessage[index].message);
                    },
                  );
                },
              ),
            ),
            // Mesaj Giriş Alanı
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey,
                        filled: true,
                        hintText: "Mesajınızı yazın...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
                ],
              ),
            ),
            SizedBox(height: 12),
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
}
