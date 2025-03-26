import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  final String sender; // gönderici
  final String receiver; // alıcı
  final String message; // mesaj
  final bool isMessageSender; //mesajı ben mi gönderdim ?
  final DateTime date; // mesaj tarihi
  ChatModel({
    required this.sender,
    required this.receiver,
    required this.message,
    required this.isMessageSender,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'isMessageSender': isMessageSender,
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      sender: map['sender']  ?? "",
      receiver: map['receiver'] ?? "",
      message: map['message'] ?? "",
      isMessageSender: map['isMessageSender'] as bool,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) => ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
