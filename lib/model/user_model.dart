import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userID;
  String? email;
  String? userName;
  String? profileURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;

  UserModel({
    required this.userID,
    this.email,
    this.userName,
    this.profileURL,
    this.createdAt,
    this.updatedAt,
    this.level,
  });

  // Nesneyi Map'e çevirme
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email ?? '',
      'userName':
          userName ?? email!.substring(0, email!.indexOf('@')) + randomNumber(),
      'profileURL': profileURL ?? "https://picsum.photos/200",

      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  // Firestore'dan gelen veriyi modele dönüştürme
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userID: map['userID'] ?? '',
      email: map['email'],
      userName: map['userName'],
      profileURL: map['profileURL'] ?? "https://picsum.photos/id/237/200/300",

      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      level: map['level'] ?? 1,
    );
  }
  String randomNumber() {
    int rnd = Random().nextInt(9999);
    return rnd.toString();
  }
}
