import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/constant/app/firebase_exeption_handler.dart';
import 'package:live_chat/model/chat_model.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/database_base.dart';

class FirestoreDbService implements DatabaseBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel? user) async {
    if (user == null || user.userID.isEmpty) {
      print('Hata: Kullanıcı bilgisi geçersiz!');
      return false;
    }

    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.userID)
          .set(user.toMap());

      DocumentSnapshot<Map<String, dynamic>> _readUser =
          await _firebaseFirestore.collection('users').doc(user.userID).get();

      Map<String, dynamic>? readResult = _readUser.data();

      if (readResult == null) {
        print('Hata: Kullanıcı Firestore\'dan okunamadı!');
        return false;
      }

      UserModel _readUserInfo = UserModel.fromMap(readResult);
      print('Firestore\'dan okunan kullanıcı: ${_readUserInfo.email}');

      return true;
    } on FirebaseException catch (e) {
      print(FirebaseExceptionHandler.handleFirebaseFirestoreException(e));
      return false;
    } catch (e) {
      print(FirebaseExceptionHandler.handleGenericException(e as Exception));
      return false;
    }
  }

  @override
  Future<UserModel?> getUser(String userID) async {
    try {
      DocumentSnapshot _getUser =
          await _firebaseFirestore.collection('users').doc(userID).get();

      if (_getUser.exists) {
        Map<String, dynamic>? _getUserMap =
            _getUser.data() as Map<String, dynamic>?;

        if (_getUserMap != null) {
          print(_getUserMap.toString());
          return UserModel.fromMap(_getUserMap);
        }
      }
      return null; // Kullanıcı bulunamazsa `null` döndür
    } on FirebaseException catch (e) {
      print(FirebaseExceptionHandler.handleFirebaseFirestoreException(e));
      return null;
    } catch (e) {
      print(FirebaseExceptionHandler.handleGenericException(e as Exception));
      return null;
    }
  }

  @override
  Future<bool> updateUserName(String userID, String userName) async {
    var users =
        await _firebaseFirestore
            .collection("users")
            .where("userName", isEqualTo: userName)
            .get();

    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseFirestore.collection("users").doc(userID).update({
        "userName": userName,
      });
      return true;
    }
  }

  @override
  Future<String> uploadFile(String userID, String fileType, File uploadFile) {
    // TODO: implement uploadFile
    throw UnimplementedError();
  }

  // kullanıcılar getiren fonk
  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot users = await _firebaseFirestore.collection("users").get();
      List<UserModel> userList = [];

      for (DocumentSnapshot user in users.docs) {
        print("Read user: " + user.data().toString());

        UserModel userModel = UserModel.fromMap(
          user.data() as Map<String, dynamic>,
        );
        userList.add(userModel);
      }

      return userList;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  @override
  Stream<List<ChatModel>> getMessage(
    String senderUserID,
    String receiverUserID,
  ) {
    var snapshots =
        _firebaseFirestore
            .collection("chats")
            .doc("$senderUserID---$receiverUserID")
            .collection("chat")
            .orderBy("date")
            .snapshots();
    return snapshots.map((msjList) {
      print(
        "Firebase’den gelen snapshot: ${msjList.docs.map((e) => e.data())}",
      );
      return msjList.docs.map((msj) => ChatModel.fromMap(msj.data())).toList();
    });
  }

  @override
  Future<bool> saveMessage(ChatModel savedMessage) async {
    try {
      var messageID = _firebaseFirestore.collection("chats").doc().id;
      var myDocID = "${savedMessage.sender}---${savedMessage.receiver}";
      var receiverDocID = "${savedMessage.receiver}---${savedMessage.sender}";
      var savedMessageToMap = savedMessage.toMap();

      await _firebaseFirestore
          .collection("chats")
          .doc(myDocID)
          .collection("chat")
          .doc(messageID)
          .set(savedMessageToMap);

      savedMessageToMap.update("isMessageSender", (value) => false);
      await _firebaseFirestore
          .collection("chats")
          .doc(receiverDocID)
          .collection("chat")
          .doc(messageID)
          .set(savedMessageToMap);
      print("Mesaj kaydedildi: ${savedMessage.message}");
      print("Kaydedilen yol: $myDocID");
      return true;
    } catch (e) {
      print("Hata: $e");
      return false;
    }
  }
}
