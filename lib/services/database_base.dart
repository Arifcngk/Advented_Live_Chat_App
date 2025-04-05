import 'dart:io';

import 'package:live_chat/model/chat_model.dart';
import 'package:live_chat/model/message_model.dart';
import 'package:live_chat/model/user_model.dart';

abstract class DatabaseBase {
  Future<bool> saveUser(UserModel? user);
  Future<UserModel?> getUser(String userID);
  Future<bool> updateUserName(String userID, String userName);
  Future<String> uploadFile(String userID, String fileType, File uploadFile);
  Future<List<UserModel>> getAllUsers();
  Future<List<MessageModel>> getAllConversations(String userID);

  Stream<List<ChatModel>> getMessage(
    String senderUserID,
    String receiverUserID,
  );
  Future<bool> saveMessage(ChatModel savedMessage);
}
