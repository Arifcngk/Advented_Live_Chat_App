import 'dart:io';

import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/model/chat_model.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/repository/user_repo.dart';
import 'package:live_chat/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _user;

  // set-get user
  UserModel? get user => _user;
  set user(UserModel? value) {
    _user = value;
    notifyListeners(); // Değişiklik olduğunda dinleyenleri haberdar etmek için
  }

  // set-get state
  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners(); // Değişiklik olduğunda dinleyenleri haberdar etmek için
  }

  // Ne zaman ki viewdeol de bir nesne üretilecek o zaman bu metot çalışacak
  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      print('ViewModeldeki currentUser: ${_user?.toString()}');
      return _user;
    } catch (e) {
      print('ViewModeldeki currentUser hatası: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      print('ViewModeldeki anonim giriş: ${_user?.toString()}');
      return _user;
    } catch (e) {
      print('ViewModeldeki anonim giriş hatası: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool?> signOut() async {
    try {
      state = ViewState.Busy;
      var result = await _userRepository.signOut();
      print('ViewModeldeki signout: ${_user?.toString()}');
      user = null;
      return result;
    } catch (e) {
      print('ViewModeldeki signout hatası: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInGoogle();
      print('ViewModeldeki google giriş: ${_user?.toString()}');
      return _user;
    } catch (e) {
      print('ViewModeldeki google giriş hatası: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> createEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.createEmailAndPassword(email, password);
      print('ViewModeldeki Create User oluşturma: ${_user?.toString()}');
      return _user;
    } catch (e) {
      print('ViewModeldeki Creatuser oluşturma  hatası: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> sigInEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.sigInEmailAndPassword(email, password);
      print('ViewModeldeki Create User oluşturma: ${_user?.toString()}');
      return _user;
    } catch (e) {
      print('ViewModeldeki Creatuser oluşturma  hatası: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> updateUserName(String userID, String userName) async {
    state = ViewState.Busy;
    var result = await _userRepository.updateUserName(userID, userName);
    if (result) {
      user!.userName = userName;
    }
    state = ViewState.Idle;
    return result;
  }

  // firestore
  Future<String> uploadFile(
    String userID,
    String fileType,
    File? userProfilePhoto,
  ) async {
    var result = await _userRepository.uploadFile(
      userID,
      fileType,
      userProfilePhoto,
    );
    return result;
  }

  // cloudera
  Future<String> uploadClouderaFile(
    String userID,
    String fileType,
    File file,
  ) async {
    var result = await _userRepository.uploadClouderaFile(
      userID,
      fileType,
      file,
    );
    return result;
  }

  Future<List<UserModel>> getAllUser() async {
    var getAllUserList = await _userRepository.getAllUser();
    return getAllUserList;
  }

  Stream<List<ChatModel>> getMessages(String currentUser, String chatUser) {
    return _userRepository.getMessages(currentUser, chatUser);
  }

  Future<bool> saveMessage(ChatModel savedMessage) {
    return _userRepository.saveMessage(savedMessage);
  }
}
