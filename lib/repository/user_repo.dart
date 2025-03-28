import 'dart:io';

import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/model/chat_model.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/fake_auth_service.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firebase_storege_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';

// ignore: constant_identifier_names
enum AppModde { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();
  final FirebaseStoregeService _firebaseStoregeService =
      locator<FirebaseStoregeService>();

  // Uygulama Hangi modda başlatılsın ?
  AppModde appModde = AppModde.RELEASE;
  @override
  Future<UserModel?> currentUser() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel? user = await _firebaseAuthService.currentUser();
      return await _firestoreDbService.getUser(user!.userID);
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool?> signOut() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInGoogle() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.signInGoogle();
    } else {
      UserModel? user = await _firebaseAuthService.signInGoogle();
      bool result = await _firestoreDbService.saveUser(user);
      if (result == true) {
        return await _firestoreDbService.getUser(user!.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> createEmailAndPassword(
    String email,
    String password,
  ) async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.createEmailAndPassword(email, password);
    } else {
      UserModel? user = await _firebaseAuthService.createEmailAndPassword(
        email,
        password,
      );
      bool result = await _firestoreDbService.saveUser(user);
      if (result == true) {
        return await _firestoreDbService.getUser(user!.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> sigInEmailAndPassword(
    String email,
    String password,
  ) async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.sigInEmailAndPassword(email, password);
    } else {
      UserModel? user = await _firebaseAuthService.sigInEmailAndPassword(
        email,
        password,
      );

      return await _firestoreDbService.getUser(user!.userID);
    }
  }

  Future<bool> updateUserName(String userID, String userName) async {
    if (appModde == AppModde.DEBUG) {
      return false;
    } else {
      return await _firestoreDbService.updateUserName(userID, userName);
    }
  }

  Future<String> uploadFile(
    String userID,
    String fileType,
    File? userProfilePhoto,
  ) async {
    if (appModde == AppModde.DEBUG) {
      return "";
    } else {
      return await _firebaseStoregeService.uploadFile(
        userID,
        fileType,
        userProfilePhoto!,
      );
    }
  }

  Future<String> uploadClouderaFile(
    String userID,
    String fileType,
    File file,
  ) async {
    if (appModde == AppModde.DEBUG) {
      return "";
    } else {
      return await _firebaseStoregeService.uploadFile(userID, fileType, file);
    }
  }

  Future<List<UserModel>> getAllUser() async {
    if (appModde == AppModde.DEBUG) {
      return [];
    } else {
      var getAllUsersList = await _firestoreDbService.getAllUsers();
      return getAllUsersList;
    }
  }

  Stream<List<ChatModel>> getMessages(String currentUser, String chatUser) {
    // if (appModde == AppModde.DEBUG) {
    //   print("stream debug modda çalışıyor");
    //   return Stream.empty();
    // } else {
    //   print("stream currentUser" + currentUser);
    //   print("stream chatuser" + chatUser);

    //   print("stream debug modda çalışıyor");

    //   return _firestoreDbService.getMessage(currentUser, chatUser);
    // }
    return _firestoreDbService.getMessage(currentUser, chatUser);
  }

  Future<bool> saveMessage(ChatModel savedMessage) async {
    if (appModde == AppModde.DEBUG) {
      return true;
    } else {
      return _firestoreDbService.saveMessage(savedMessage);
    }
  }
}
