import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/locator.dart';
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
  Future<UserModel?> createEmailAndPassword(String email, String password) {
    // TODO: implement createEmailAndPassword
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel?> sigInEmailAndPassword(String email, String password) {
    // TODO: implement sigInEmailAndPassword
    throw UnimplementedError();
  }
}
