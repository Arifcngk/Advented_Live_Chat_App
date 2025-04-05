import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String owner; // Mesajı gönderen kişi (sahibi)
  final String chatWith; // Mesajın gönderildiği kişi
  final bool isRead; // Mesaj okundu mu
  final String lastMessage; // Son mesaj
  final Timestamp timestamp; // mesajın oluşturulma tarihi
  final Timestamp sighting; // Mesajın görülme tarihi
  late String chatWithID;
  late String chatWithProfileURL;

  MessageModel({
    required this.owner,
    required this.chatWith,
    required this.isRead,
    required this.lastMessage,
    required this.timestamp,
    required this.sighting,
  });

  // Firestore'a kaydetmek için
  Map<String, dynamic> toMap() {
    return {
      'owner': owner,
      'chat_with': chatWith,
      'isRead': isRead,
      'last_message': lastMessage,
      'timestamp': timestamp,
      'sighting': sighting,
    };
  }

  // Firestore'dan okurken kullanmak için
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      owner: map['owner'] ?? '',
      chatWith: map['chat_with'] ?? '',
      isRead: map['isRead'] ?? false,
      lastMessage: map['last_message'] ?? '',
      timestamp:
          map['timestamp'] is Timestamp ? map['timestamp'] : Timestamp.now(),
      sighting:
          map['sighting'] is Timestamp ? map['sighting'] : Timestamp.now(),
    );
  }

  // To string method to represent the object as a string
  @override
  String toString() {
    return 'MessageModel(owner: $owner, chat_with: $chatWith, isRead: $isRead, last_message: $lastMessage, timestamp: ${timestamp.toDate()}, sighting: ${sighting.toDate()})';
  }
}
