import 'package:firebase_auth/firebase_auth.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(userID: user.uid);
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print('Hata: Firebase Auth Service - currentUser: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print('Hata: Firebase Auth Service - signInAnonymously: $e');
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('Hata: Firebase Auth Service - signOut: $e');
      return false;
    }
  }
}
